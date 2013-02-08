class AddDivisionToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :division_id, :integer
  end

  def self.down
    remove_column :events, :division_id
  end
end
