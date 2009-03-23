set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
ssh_options[:forward_agent] = true
default_run_options[:pty] = true


set :application, "smidig2009"
set :repository,  "http://svn.smidig.no/smidig2009"

set(:deploy_to) { "/home/smidig_no/apps/#{application}/#{stage}" }
set(:rails_env) { stage }
set :database, "#{application}_#{environment}"

set :user, "smidig_no"
set :domain, "bubbleyum.dreamhost.com"
set :use_sudo, false

role :web, domain
role :app, domain
role :db, domain, :primary => true


namespace :db do
  desc "Create database yaml in shared path" 
  task :default do
    puts "Please enter the database password for #{stage}:"
    db_config =  <<-EOF
#{stage}:
  adapter: mysql
  database: #{database}
  username: smidig_no
  password: #{password}
  host: mysql.smidig.no
  encoding: utf8
EOF
    run "mkdir -p #{shared_path}/config" 
    put db_config, "#{shared_path}/config/database.yml" 
  end
end
after "deploy:setup", "db:default"

task :setup_link do
  run "if [ -L /home/smidig_no/#{domain} ]; then rm /home/smidig_no/#{domain}; fi"
  run "ln -s #{current_path}/public /home/smidig_no/#{domain}"
end
after "deploy:setup", "setup_link"

task :update_config, :roles => [:app] do
  run "cp -Rf #{shared_path}/config/* #{release_path}/config"
end
after "deploy:update_code", :update_config



namespace :deploy do
  desc "Restart the application by tmp/restart.txt for mod_rails."
  task :start, :roles => :app, :except => { :no_release => true } do
    run "touch  #{release_path}/tmp/restart.txt"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch  #{release_path}/tmp/restart.txt"
  end
end
