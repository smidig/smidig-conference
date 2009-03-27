# TODO: There must be a good way to display current progress
# TODO: Implement better error handling in Rake

def execute_on_server(config)
  Net::SSH.start(config[:hostname], config[:username], :password => config[:password]) do |ssh|
    yield ssh
  end
rescue Net::SSH::AuthenticationFailed
 $stdout.puts "Authentication failed for #{config[:username]}@#{config[:hostname]}"
end


namespace :deploy do
  require 'net/ssh'
  require 'net/scp'
  
  # TODO What's the best place to get this from?
  application = "smidig2009"

  svn_root = "http://svn.smidig.no/smidig2009/#{application}"
  hostname = 'bubbleyum.dreamhost.com'
  deploy_path = "/home/smidig_no/test/#{application}"
  username = 'smidig_no'
  password = nil
  dbusername = username
  dbpassword = password
    
  %w(staging production).each do |stage|
    namespace stage do
      stage_path = "#{deploy_path}/#{stage}"
      application_path = "#{stage_path}/#{application}"
      database = "#{application}_#{stage}"
      config = { :hostname => hostname, :username => username, :password => password }

      desc "Create initial structure for #{stage}"
      task :setup do
        execute_on_server(config) do |ssh|
          ssh.exec! "rm -rf #{stage_path}; mkdir -p #{stage_path}"
          ssh.exec! "cd #{stage_path}; svn co #{svn_root} #{application}"

          database_config =<<-EOF
#{stage}:
  adapter: mysql
  database: #{dbdatabase}
  username: smidig_no
  password: #{dbpassword}
  host: mysql.smidig.no
  encoding: utf8
EOF
          ssh.scp.upload! StringIO.new(database_config), "#{application_path}/config/database.yml"
        end
      end
      
      desc "Update the code in #{stage}. Add variable REVISION=... update to a given revision"
      task :update do
        execute_on_server(config) do |ssh|
          revision = ENV['REVISION'] || 'HEAD'
          ssh.exec! "cd #{application_path} && svn up --revision #{revision}"
        end
      end
      
      desc "Migrate the database in #{stage}. Add variable VERSION=... update to a given version"
      task :migrate do
        execute_on_server(config) do |ssh|
          version = ENV["VERSION"] ? "VERSION=ENV['VERSION']" : ""
          ssh.exec! "cd #{application_path} && rake db:migrate #{version}"
        end
      end
    end
  end
end
