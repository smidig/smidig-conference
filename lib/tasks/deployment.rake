# TODO: Extract this...
def execute_on_server(config)
  login = "#{config[:username]}@#{config[:hostname]}"
  $stdout.puts "[#{login}] Logging in"
  Net::SSH.start(config[:hostname], config[:username], :password => config[:password]) do |ssh|
    yield Connection.new(login, ssh)
  end
rescue Net::SSH::AuthenticationFailed
 $stdout.puts "Authentication failed for #{config[:username]}@#{config[:hostname]}"
end

def server_task(taskname, config)
  task taskname do
    execute_on_server(config) { |conn| yield conn }
  end
end

class Connection
  def initialize(login, ssh)
    @login = login
    @ssh = ssh
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
  def upload(io, path)
    $stdout.puts "[#{@login}] Uploading #{path}"
    @ssh.scp.upload! io, path
  end
end


namespace :deploy do
  require 'net/ssh'
  require 'net/scp'
  
  # TODO What's the best place to get this from?
  application = "smidig2009"

  svn_root = "http://svn.smidig.no/smidig2009/#{application}"
  hostname = 'bubbleyum.dreamhost.com'
  apps_path = "/home/smidig_no/apps"
  username = 'smidig_no'
  password = nil
  dbusername = username
  dbpassword = password
  dbhost = 'mysql.smidig.no'
    
  %w(staging production).each do |stage|
    namespace stage do
      application_path = "#{apps_path}/#{application}/#{stage}/#{application}"
      database = "#{application}_#{stage}"
      config = { :hostname => hostname, :username => username, :password => password }

      server_task :checkout, config do |connection|
        connection.exec "rm -rf #{application_path}"

        revision = ENV['REVISION'] || 'HEAD'
        connection.exec "svn checkout --revision #{revision} #{svn_root} #{application_path}"

        database_config =<<-EOF
#{stage}:
  adapter: mysql
  database: #{database}
  username: #{dbusername}
  password: #{dbpassword}
  host: #{dbhost}
  encoding: utf8
EOF
        connection.upload StringIO.new(database_config), "#{application_path}/config/database.yml"
      end
      
      server_task :prepare, config do |connection|
        connection.exec "cd #{application_path} && rake gems:install RAILS_ENV=#{stage}"
        connection.exec "cd #{application_path} && rake rails:freeze:gems RAILS_ENV=#{stage}"
        connection.exec %Q(echo "RAILS_ENV='#{stage}'" > #{application_path}/tmp/environment.rb)
        connection.exec "touch #{application_path}/tmp/restart.txt"
      end
      
      desc "Create initial structure for #{stage}"
      task :setup => [:checkout, :prepare]
      
      desc "Update the code in #{stage}. Add variable REVISION=... update to a given revision"
      server_task :update, config do |connection|
        revision = ENV['REVISION'] || 'HEAD'
        connection.exec "svn up --revision #{revision} #{application_path}"
        connection.exec "touch #{application_path}/tmp/restart.txt"
      end
      
      desc "Migrate the database in #{stage}. Add variable VERSION=... update to a given version"
      server_task :migrate, config do |connection|
        version = ENV["VERSION"] ? "VERSION=ENV['VERSION']" : ""
        connection.exec "cd #{application_path} && rake db:migrate #{version}"
      end
    end
  end
end
