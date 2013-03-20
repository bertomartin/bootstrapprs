set :application, "bootstrappr" # app name

server "xx.xx.xx.xx", :web, :app, :db, primary: true

# need deploy keys up to github or this chokes
set :scm, :git
set :repository,  "git@github.com:bertomartin/bootstrappr.git"
set :branch, "master"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false


default_run_options[:pty] = true
ssh_options[:forward_agent] = true



# Apache/Passenger setup/deploy commands
namespace :deploy do

  # Apache/Passenger related commands
  task :start do
    sudo "a2ensite #{application}"
    sudo "service apache2 reload"
  end
  task :stop do
    sudo "a2dissite #{application}"
    sudo "service apache2 reload"
  end
  task :restart, roles: :app, except: {no_release: true} do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end

  # Update apache.conf
  task :apache_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/apache.conf /etc/apache2/sites-available/#{application}"
  end
  after "deploy:setup", "deploy:apache_config"

end