set :application, "clubsoccer"
set :repository,  "git@github.com:subbuthepeaceful/clubsoccer.git"

set :scm, :git
set :user, "clubsoccer"
set :deploy_to, "/home/clubsoccer/applications/#{application}"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "75.98.32.39"                          # Your HTTP server, Apache/etc
role :app, "75.98.32.39"                          # This may be the same as your `Web` server
role :db,  "75.98.32.39", :primary => true # This is where Rails migrations will run

set :use_sudo, false
set :keep_releases, 5

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

#If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end