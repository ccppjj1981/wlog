set :stages, %w(production)
set :default_stage, 'production'
require 'mina/multistage'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina/puma'
require "mina_sidekiq/tasks"
require 'mina/logs'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)


# Optional settings:
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# set :shared_dirs, fetch(:shared_dirs, []).push('somedir')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')
#puma -b unix:///home/ubuntu/wblog/wlog/shared/sockets/puma.sock
# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
set :shared_paths, ['config/database.yml', 'config/application.yml', 'log', 'public/uploads']
set :puma_config, ->{ "#{deploy_to}/#{current_path}/config/puma.rb" }
set :sidekiq_pid, ->{ "#{deploy_to}/#{shared_path}/tmp/pids/sidekiq.pid" }

task :environment do
  invoke :'rbenv:load'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/shared/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/public/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/public/uploads"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/application.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/application.yml'"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml'"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  queue  %[echo "-----> Server: #{domain}"]
  queue  %[echo "-----> Path: #{deploy_to}"]
  queue  %[echo "-----> Branch: #{branch}"]

  deploy do
    invoke :'sidekiq:quiet'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      invoke :'puma:hard_restart'
      invoke :'sidekiq:restart'
    end
  end
end

desc "Deploys the current version to the server."
task :first_deploy => :environment do
  queue  %[echo "-----> Server: #{domain}"]
  queue  %[echo "-----> Path: #{deploy_to}"]
  queue  %[echo "-----> Branch: #{branch}"]

  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'deploy:cleanup'

    to :launch do
      invoke :'rails:db_create'
    end
  end
end
