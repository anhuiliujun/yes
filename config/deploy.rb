# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'central_authority'
set :repo_url, 'git@gitlab.icar99.com:zc/central_authority.git'
set :deploy_to, "/home/wisdom/central_authority"
set :scm, :git

set :linked_files, fetch(:linked_files, []).push('config/sms_client.yml', 'config/database.yml', 'config/initializers/secret_token.rb', '.ruby-version')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/uploads')
set :keep_releases, 5
set :deploy_via, :remote_cache
set :pty, true

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc "rake db seed"
  task :db_seed do
    on roles(:db) do
      within current_path do
          execute :sudo, "#{fetch(:rvm_path)}/bin/rvm #{fetch(:rvm_ruby_version)} do rake db:seed RAILS_ENV=#{fetch(:rails_env)}"
          execute :sudo, "#{fetch(:rvm_path)}/bin/rvm #{fetch(:rvm_ruby_version)} do rake info_categories:init RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
  end

  desc 'install bundler'
  task :install_bundler do
    on roles(:app) do
      execute 'gem install bundler'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma

