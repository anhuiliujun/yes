role :app, %w{deploy@121.40.229.244 deploy@114.215.198.108}
role :web, %w{deploy@121.40.229.244 deploy@114.215.198.108}
role :db,  %w{deploy@121.40.229.244}

set :deploy_to, "/var/www/central_authority"

set :rvm_type, :system
set :rvm_ruby_version, '2.2.3'

set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"
set :nginx_sites_available_path, "/etc/nginx/sites-available"
set :nginx_server_name, "nimda.icar99.cn"
set :puma_init_active_record, true

set :rails_env, "production"
set :branch, 'master'

set :monit_role, :all

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  before :starting,     :check_revision
end
