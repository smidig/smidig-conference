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


namespace :dreamhost do  
  # TODO What's the best place to get this from?
  application = "smidig2009"

  svn_root = "http://svn.smidig.no/smidig2009/#{application}"
  hostname = 'smidig2009.no'
  apps_path = "/home/smidig_no/apps"
  username = 'smidig_no'
  dbusername = username
  $dbpassword = nil
  dbhost = 'mysql.smidig.no'
    
  %w(staging production experimental).each do |environment|
    
    desc "Updates the installed version on #{environment}"
    task environment => "dreamhost:#{environment}:update"
    
    namespace environment do
      application_path = "#{apps_path}/#{application}/#{environment}/#{application}".chomp
      database = "#{application}_#{environment}"
      server = Server.new :hostname => hostname, :username => username, :application_path => application_path, :environment => environment

      desc "Create initial structure for #{environment}"
      server.remote_task :setup => :get_dbpassword do |connection|
        connection.exec "rm -rf #{application_path}"

        revision = ENV['REVISION'] || 'HEAD'
        connection.exec "svn checkout --revision #{revision} #{svn_root} #{application_path}"
        connection.exec %Q(cd #{application_path} && echo "`date` => `svn info | grep Revision:`" >> log/deployment.log)

        config = database_config(environment, database, dbusername, $dbpassword, dbhost)
        
        if environment == 'production'
          twitter_config = twitter_config(environment, 'smidig', $dbpassword)
          connection.upload_text twitter_config, "tmp/twitter.yml"
        end
        
        connection.upload_text config, "tmp/database.yml"
        connection.upload_text "RAILS_ENV='#{environment}'", "tmp/environment.rb"

        connection.rake ["rails:freeze:gems", "gems:unpack", "db:migrate"]

        connection.touch "tmp/restart.txt"
      end
      
      desc "Update the code in #{environment}. Add variable REVISION=... update to a given revision"
      server.remote_task :update do |connection|
        revision = ENV['REVISION'] || 'HEAD'
        connection.exec "svn up --revision #{revision} #{application_path}"
        connection.exec %Q(cd #{application_path} && echo "`date` => `svn info | grep Revision:`" >> log/deployment.log)
        connection.rake ["gems:unpack", "cache:expire_all"]
        connection.touch "tmp/restart.txt"
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
  
  desc "Upgrade all environments - use for really small changes"
  task :all => ["dreamhost:experimental", "dreamhost:staging", "dreamhost:production"]
  
  task :get_backup do
    $stdout.puts "[#{username}@#{hostname}] scp backup/smidig2009_production/latest-dump.gz db/"
    require 'net/scp'
    Net::SCP.download!(hostname, username, "backup/smidig2009_production/latest-dump.gz", "db/")    
  end
end
