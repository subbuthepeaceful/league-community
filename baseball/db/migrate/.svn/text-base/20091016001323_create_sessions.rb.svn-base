class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.column :program_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :description, :string
      t.column :start_date, :datetime
      t.column :end_date, :datetime
      t.column :status, :string, :default => "Active"
    end
  end

  def self.down
    drop_table :sessions
  end
end
