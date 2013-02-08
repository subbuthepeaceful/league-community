class AddHasScheduleToDivision < ActiveRecord::Migration
  def self.up
    add_column :divisions, :has_schedule, :boolean, :default => false
  end

  def self.down
    remove_column :divisions, :has_schedule
  end
end
