


load 'config/deploy/recipes/base'

server "198.211.114.28", :web, :app, :db, primary: true

set :application, "bootstrapprs"
set :domain, "bootstrapprs.com"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:bertomartin/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:port] = 77


after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  task :start do; end
  task :stop do; end
  task :restart, roles: :app, except: {no_release: true} do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end

  task :cold do
    run "cd #{release_path}; rake install_dependencies"
  end
  before "deploy:cold", "deploy"

  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/config"
    put template('apache.conf.erb'), "#{shared_path}/config/apache.conf"
    run "#{sudo} ln -nfs #{shared_path}/config/apache.conf /etc/apache2/sites-available/#{application}"
  end
  after "deploy:setup", "deploy:setup_config"
  
  
  task :start_vhost do
    run "#{sudo} a2ensite #{application}"
    run "#{sudo} service apache2 reload"
  end
  after "deploy:cold", "deploy:start_vhost"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end
