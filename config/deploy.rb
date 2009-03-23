set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
ssh_options[:forward_agent] = true
default_run_options[:pty] = true


set :application, "smidig2009.no"
set :repository,  "http://svn.smidig.no/smidig2009"

set(:deploy_to) { "/home/smidig_no/apps/#{application}/#{stage}" }
set(:rails_env) { stage }

set :user, "smidig_no"
set :domain, "bubbleyum.dreamhost.com"

role :web, domain
role :app, domain
role :db, domain, :primary => true


namespace :mod_rails do
  desc "Restart the application by tmp/restart.txt for mod_rails."
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch  #{release_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  %w(start restart).each { |name| task name, :roles => :app do mod_rails.restart end }
end

task :copy_database_yml, :roles => :app do
  db_config = "/home/smidig_no/apps/#{application}/conf/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
end
