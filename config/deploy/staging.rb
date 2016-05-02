# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.
role :app, %w{www@120.26.201.136}
role :web, %w{www@120.26.201.136}
role :db, %w{www@120.26.201.136}


set :rvm_type, :system
set :rvm_ruby_version, '2.2.3'

set :deploy_to, "/var/www/auth_staging"

set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"
set :nginx_sites_available_path, "/etc/nginx/sites-available"
set :nginx_server_name, "yes.test.com"
set :puma_init_active_record, true

set :rails_env, "staging"
# set :branch, 'staging'

set :monit_role, :all

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

#server 'example.com', user: 'deploy', roles: %w{web app}, my_property: :my_value


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/staging`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  before :starting,     :check_revision
end
