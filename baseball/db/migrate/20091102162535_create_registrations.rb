class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.column :participant_id, :integer
      t.column :session_id, :integer
      t.column :division_id, :integer
      t.column :registered_date, :datetime
      t.column :registration_requests, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :registrations
  end
end
