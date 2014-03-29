class CreateClubs < ActiveRecord::Migration
  def up
    create_table :clubs do |t|
      t.string :name
      t.string :tagline
    end

    redstarsoccer = Club.new(name: 'Red Star Soccer', tagline: 'Player centered, coach driven, sports science inspired, and parent supported')
    redstarsoccer.save
  end

  def down
    drop_table :clubs
  end
end
