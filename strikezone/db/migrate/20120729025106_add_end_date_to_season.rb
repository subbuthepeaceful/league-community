class AddEndDateToSeason < ActiveRecord::Migration
  def up
    add_column :seasons, :end_date, :date
  end

  def down
    remove_column :seasons, :end_date
  end
end
