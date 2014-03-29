class AddEndDateToSeason < ActiveRecord::Migration
  def up
    add_column :seasons, :end_date, :date
  end

  def down
    remove_column :season, :end_date
  end
end
