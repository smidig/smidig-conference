# TODO: Extract this...
def execute_on_server(config)
  require 'net/ssh'
  require 'net/scp'

  login = "#{config[:username]}@#{config[:hostname]}"
  $stdout.puts "[#{login}] Logging in"
  Net::SSH.start(config[:hostname], config[:username]) do |ssh|
    yield Connection.new(login, ssh, config[:application_path], config[:stage])
  end
rescue Net::SSH::AuthenticationFailed
 $stdout.puts "Authentication failed for #{config[:username]}@#{config[:hostname]}"
end


def prompt_for_variable(prompt)
  puts prompt
  $stdin.gets.chomp
end

def database_config(stage, database, dbusername, dbpassword, dbhost)
  return <<-EOF
#{stage}:
  adapter: mysql
  database: #{database}
  username: #{dbusername}
  password: #{dbpassword}
  host: #{dbhost}
  encoding: utf8
EOF
end

class Server
  def initialize(config)
    @config = config
  end

  def remote_task(taskname)
    task taskname do
      execute_on_server(@config) { |conn| yield conn }
    end
  end
end

class Connection
  def initialize(login, ssh, application_path, stage)
    @login = login
    @ssh = ssh
    @application_path = application_path
    @stage = stage
  end
  def exec(command)
    $stdout.puts "[#{@login}] #{command}"
    channel = @ssh.open_channel do |ch|
      ch.exec command do |ch, success|
        success or raise "could not execute command"

        ch.on_data do |c, data|
          $stdout.print data
        end

        ch.on_extended_data do |c, type, data|
          $stderr.print data
        end

        ch.on_request "exit-status" do |ch, data|
          exit_status = data.read_long
          exit_status == 0 or raise "command failed with status: #{exit_status}"
        end
      end
    end
    channel.wait
  end
  def rake(tasks)
    tasks = [tasks] if tasks.instance_of? String
    for task in tasks
      self.exec "cd #{@application_path} && rake #{task} RAILS_ENV=#{@stage}"
    end
  end
  def upload(io, path)
    path = File.join(@application_path, path) unless path.start_with? "/"
    $stdout.puts "[#{@login}] Uploading #{path}"
    @ssh.scp.upload! io, path
  end
  def upload_text(text, path)
    upload(StringIO.new(text), path)
  end
  def touch(path)
    path = File.join(@application_path, path) unless path.start_with? "/"
    exec "touch #{path}"
  end
end


namespace :deploy do  
  # TODO What's the best place to get this from?
  application = "smidig2009"

  svn_root = "http://svn.smidig.no/smidig2009/#{application}"
  hostname = 'bubbleyum.dreamhost.com'
  apps_path = "/home/smidig_no/apps"
  username = 'smidig_no'
  dbusername = username
  $dbpassword = nil
  dbhost = 'mysql.smidig.no'
    
  %w(staging production experimental).each do |stage|
    
    desc "Updates the installed version on #{stage}"
    task stage => "deploy:#{stage}:update"
    
    namespace stage do
      application_path = "#{apps_path}/#{application}/#{stage}/#{application}"
      database = "#{application}_#{stage}"
      server = Server.new :hostname => hostname, :username => username, :application_path => application_path, :stage => stage

      desc "Create initial structure for #{stage}"
      server.remote_task :setup => :get_dbpassword do |connection|
        connection.exec "rm -rf #{application_path}"

        revision = ENV['REVISION'] || 'HEAD'
        connection.exec "svn checkout --revision #{revision} #{svn_root} #{application_path}"

        config = database_config(stage, database, dbusername, $dbpassword, dbhost)
        connection.upload_text config, "tmp/database.yml"
        connection.upload_text "RAILS_ENV='#{stage}'", "tmp/environment.rb"

        connection.rake ["rails:freeze:gems", "gems:unpack", "db:migrate"]

        connection.touch "tmp/restart.txt"
      end
      
      desc "Update the code in #{stage}. Add variable REVISION=... update to a given revision"
      server.remote_task :update do |connection|
        revision = ENV['REVISION'] || 'HEAD'
        connection.exec "svn up --revision #{revision} #{application_path}"
        connection.rake "gems:unpack"
        connection.touch "tmp/restart.txt"
      end
      
      desc "Migrate the database in #{stage}. Add variable VERSION=... update to a given version"
      server.remote_task :migrate do |connection|
        version = ENV["VERSION"] ? "VERSION=ENV['VERSION']" : ""
        connection.rake "db:migrate #{version}"
      end
      
      task :get_dbpassword do
        $dbpassword ||= prompt_for_variable("Please input database password: ")
      end
    end
  end
end
