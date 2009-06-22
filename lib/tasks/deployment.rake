require 'remote_tasks'

def prompt_for_variable(prompt)
  puts prompt
  $stdin.gets.chomp
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


$configuration = {
  :default => {
    :application => "smidig2009",
    :svn_root    => "http://svn.smidig.no/smidig2009/smidig2009",
    :adapter     => "mysql",
    :apps_path   => "/home/smidig_no/apps",
    :hostname    => "bubbleyum.dreamhost.com",
    :username    => "smidig_no",
    :dbusername  => "smidig_no",
    :dbhost      => "mysql.smidig.no",
    :jruby       => false  
  },
  :oc => {
    :hostname    => "app1.oc.capasit.net",
    :adapter     => "jdbcmysql",
    :apps_path   => "/var/apps",
    :dbhost      => "localhost",
    :jruby       => true    
  }
}

def cfg(key,environment='default')
  environment = environment.to_sym
  if $configuration.has_key?(environment) && $configuration[environment].has_key?(key)
    $configuration[environment][key]
  else 
    $configuration[:default][key]
  end
end

namespace :deploy do  
  # TODO What's the best place to get this from?
  $dbpassword = nil
      
  %w(oc staging production experimental).each do |environment|
    
    desc "Updates the installed version on #{environment}"
    task environment => "deploy:#{environment}:update"
    
    namespace environment do
      application = cfg(:application, environment)      
      svn_root = cfg(:svn_root, environment)      
      application_path = cfg(:apps_path, environment) + "/#{application}/#{environment}/#{application}".chomp
      database = "#{application}_#{environment}"

      server = Server.new(:hostname => cfg(:hostname, environment), 
                          :username => cfg(:username, environment), 
                          :application_path => application_path, 
                          :environment => environment,
                          :jruby => cfg(:jruby, environment))

      desc "Create initial structure for #{environment}"
      server.remote_task :setup => :get_dbpassword do |connection|
        connection.exec "rm -rf #{application_path}"

        revision = ENV['REVISION'] || 'HEAD'
        connection.exec "svn checkout --revision #{revision} #{svn_root} #{application_path}"
        connection.exec %Q(cd #{application_path} && echo "`date` => `svn info | grep Revision:`" >> log/deployment.log)

        config = database_config(
                      environment, 
                      cfg(:adapter, environment), 
                      database,
                      cfg(:dbusername, environment),
                      $dbpassword, 
                      cfg(:dbhost, environment))
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
end
