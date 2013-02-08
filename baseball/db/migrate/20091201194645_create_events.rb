class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :name, :string, :null => false
      t.column :description, :text
      t.column :starts, :datetime
      t.column :ends, :datetime
      t.column :location_id, :integer
      t.column :session_id, :integer
    end
  end

  def self.down
    drop_table :events
  end
end
