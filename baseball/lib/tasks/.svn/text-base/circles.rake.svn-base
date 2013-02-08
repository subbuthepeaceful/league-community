require 'config/environment'

namespace :circles do
  task :send_game_reminders do
    games = Game.find (:all, :conditions => ["date(scheduled_at) > ? AND date(scheduled_at) <= ?",Date.today, Date.today+2])
    games.each { |game|
        game.send_game_reminders if  game
    } if games
    #game = Game.find(1)
    #game.send_game_reminders
  end
end
