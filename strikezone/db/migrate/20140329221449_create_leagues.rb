class CreateLeagues < ActiveRecord::Migration
  def up
    create_table :leagues do |t|
      t.string :name
      t.string :url
    end

  end

  def down
    drop_table :leagues
  end
end
