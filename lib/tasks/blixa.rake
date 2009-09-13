require 'remote_tasks'

def prompt_for_variable(prompt)
  puts prompt
  $stdin.gets.chomp
end

def twitter_config(environment, username, password)
  return <<-EOF
#{environment}:
  username: #{username}
  password: #{password}
EOF
end

def database_config(environment, database, dbusername, dbpassword, dbhost)
  return <<-EOF
#{environment}:
  adapter: mysql
  database: #{database}
  username: #{dbusername}
  password: #{dbpassword}
  host: #{dbhost}
  encoding: utf8
EOF
end

def mongrel_config(environment, application_path, port)
  { "user" => 'deploy', "group" => 'deploy', "log_file" => "log/mongrel.log", "cwd" => application_path, 
    "port" => port, "servers" => 4, "environment" => environment, "pid_file" => 'tmp/pids/mongrel.pid',
    "address" => '127.0.0.1' }.to_yaml
end

def smf_config(environment)
  require 'erb'
  ERB.new(File.read("config/blixa/smidig2009.smf.xml.erb")).result(binding)
end

def nginx_config(environment, application_path, port)
  require 'erb'
  hostname = (environment == "production" ? "" : environment+".")  + "2.smidig2009.no"
  ERB.new(File.read("config/blixa/smidig2009-nginx.conf.erb")).result(binding)
end


namespace :blixa do  
  # TODO What's the best place to get this from?
  application = "smidig2009"

  svn_root = "http://svn.smidig.no/smidig2009/#{application}"
  hostname = 'blixa.arktekk.no'
  apps_path = "/u/apps"
  username = 'deploy'
  dbusername = "smidig_no"
  $dbpassword = nil
  dbhost = 'localhost'
  
  config = {
    "production" =>   { :port => 5500 },
    "staging" =>      { :port => 5510 },
    "experimental" => { :port => 5520 },
  }
    
  %w(staging production experimental).each do |environment|
    
    desc "Updates the installed version on #{environment}"
    task environment => "dreamhost:#{environment}:update"
    
    namespace environment do
      application_path = "#{apps_path}/#{application}/#{environment}/#{application}".chomp
      database = "#{application}_#{environment}"
      server = Server.new :hostname => hostname, :username => username, :application_path => application_path, :environment => environment
      port = config[environment][:port]
      
      desc "Create initial structure for #{environment}"
      server.remote_task :setup => :get_dbpassword do |connection|
        connection.exec "rm -rf #{application_path}"
        connection.exec "mkdir -p #{application_path}"

        revision = ENV['REVISION'] || 'HEAD'
        connection.exec "/usr/bin/svn checkout --revision #{revision} #{svn_root} #{application_path}"
        connection.exec %Q(cd #{application_path} && echo "`date` => `/usr/bin/svn info | grep Revision:`" >> log/deployment.log)

        connection.upload_text "RAILS_ENV='#{environment}'", "tmp/environment.rb"
        connection.upload_text database_config(environment, database, dbusername, $dbpassword, dbhost), "tmp/database.yml"        
        connection.upload_text mongrel_config(environment, application_path, port+0), "tmp/mongrel_cluster.yml"
        
        if environment == 'production'
          connection.upload_text twitter_config(environment, 'smidig', $dbpassword), "tmp/twitter.yml"
        end
        
        connection.upload_text smf_config(environment), "tmp/smidig2009-#{environment}.smf.xml"
        # TODO: Must be done by root
        #connection.exec "svccfg import #{application_path}/tmp/smidig2009-#{environment}.smf.xml"
        connection.upload_text nginx_config(environment, application_path, port), "/opt/nginx/conf/sites/smidig2009-#{environment}.no.conf"

        # TODO: db:create doesn't read the correct database configuration
        connection.rake ["rails:freeze:gems", "gems:unpack", "db:migrate"]
        
        connection.exec "sudo svcadm restart svc:/network/nginx:default"
        connection.exec "sudo svcadm restart svc:/network/mongrel/smidig2009:#{environment}"
      end
      
      desc "Update the code in #{environment}. Add variable REVISION=... update to a given revision"
      server.remote_task :update do |connection|
        revision = ENV['REVISION'] || 'HEAD'
        connection.exec "/usr/bin/svn up --revision #{revision} #{application_path}"
        connection.exec %Q(cd #{application_path} && echo "`date` => `/usr/bin/svn info | grep Revision:`" >> log/deployment.log)
        connection.rake ["gems:unpack", "cache:expire_all"]
        connection.exec "svcadm restart svc:/network/mongrel/smidig2009:#{environment}"
      end
      
      desc "Migrate the database in #{environment}. Add variable VERSION=... update to a given version"
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
