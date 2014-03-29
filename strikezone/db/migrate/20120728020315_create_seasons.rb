class CreateSeasons < ActiveRecord::Migration
  def up
    create_table :seasons do |t|
      t.string :name, :null => false
      t.date :start_date
    end
  end

  def down
    drop_table :seasons
  end
end
