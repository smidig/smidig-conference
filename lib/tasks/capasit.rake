require 'remote_tasks'
require 'yaml'

def prompt_for_variable(prompt)
  puts prompt
  $stdin.gets.chomp
end

def glassfish_gem_config(environment, port)
  return <<-EOF
environment: #{environment}
http:
    port: #{port}
    contextroot: /
log:
    # Logging level. Log level 0 to 7. 0:OFF, 1:SEVERE, 2:WARNING, 3:INFO (default), 4:FINE, 5:FINER, 6:FINEST, 7:ALL.
    log-level: 3
jruby-runtime-pool:
    initial: 1
    min: 1
    max: 1
daemon:
    enable: true
    # DEFAULT jvm-options: -server -Xmx512m -XX:MaxPermSize=192m -XX:NewRatio=2 -XX:+DisableExplicitGC -Dhk2.file.directory.changeIntervalTimer=6000
    #jvm-options: -server -Xmx2500m -Xms64m -XX:PermSize=256m -XX:MaxPermSize=256m -XX:NewRatio=2 -XX:+DisableExplicitGC -Dhk2.file.directory.changeIntervalTimer=6000  
EOF
end

def database_config(environment, adapter, database, dbusername, dbpassword, dbhost)
  return <<-EOF
#{environment}:
  adapter: #{adapter}
  database: #{database}
  username: #{dbusername}
  password: #{dbpassword}
  host: #{dbhost}
  encoding: utf8
EOF
end

def twitter_config(environment, username, password)
  return <<-EOF
#{environment}:
  username: #{username}
  password: #{password}
EOF
end 

class Hash
  def symbolize_keys
    inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key) || key] = value
      options
    end
  end
end

namespace :capasit do
  $dbpassword = nil

  %w(staging production experimental).each do |environment|
    cfg = YAML::load(File.open(File.join(File.dirname(__FILE__), '../../config/capasit.yml')))[environment].symbolize_keys

    desc "Updates the installed version on #{environment}"
    task environment => "deploy:#{environment}:update"

    namespace environment do
      application = cfg[:application]
      svn_root = cfg[:svn_root]
      application_path = cfg[:apps_path] + "/#{application}/#{environment}/#{application}".chomp
      database = "#{application}_#{environment}"

      server = Server.new(:hostname => cfg[:hostname],
                          :username => cfg[:username], 
                          :application_path => application_path, 
                          :environment => environment, 
                          :jruby => cfg[:jruby])

      desc "Create initial structure for #{environment}"
      server.remote_task :setup => :get_dbpassword do |connection|
        connection.exec "rm -rf #{application_path}"

        revision = ENV['REVISION'] || 'HEAD'
        connection.exec "svn checkout --revision #{revision} #{svn_root} #{application_path}"
        connection.exec %Q(cd #{application_path} && echo "`date` => `svn info | grep Revision:`" >> log/deployment.log)

        config = database_config(environment, cfg[:adapter], database, cfg[:dbusername], $dbpassword, cfg[:dbhost])
        glassfish_config = glassfish_gem_config(environment, cfg[:glassfish_port])

        #if environment == 'production'
          twitter_config = twitter_config(environment, cfg[:twitter_user], $dbpassword)
          connection.upload_text twitter_config, "tmp/twitter.yml"
        #end

        connection.upload_text config, "tmp/database.yml"
        connection.upload_text glassfish_config, "tmp/glassfish.yml"        
        connection.upload_text "RAILS_ENV='#{environment}'", "tmp/environment.rb"
        connection.rake ["rails:freeze:gems", "gems:unpack", "db:migrate"]
        connection.exec "/usr/sbin/svcadm enable glassfish-gem:smidig2009_#{environment}" 
      end

      desc "Update the code in #{environment}. Add variable REVISION=... update to a given revision"
      server.remote_task :update do |connection|
        revision = ENV['REVISION'] || 'HEAD'
        connection.exec "svn up --revision #{revision} #{application_path}"
        connection.exec %Q(cd #{application_path} && echo "`date` => `svn info | grep Revision:`" >> log/deployment.log)
        connection.rake ["gems:unpack", "cache:expire_all"]
        connection.exec "/usr/sbin/svcadm restart glassfish-gem:smidig2009_#{environment}" 
      end

      desc "Disable #{environment}."
      server.remote_task :undeploy do |connection|
        connection.exec "/usr/sbin/svcadm disable glassfish-gem:smidig2009_#{environment}"
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
