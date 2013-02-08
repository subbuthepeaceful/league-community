class CreateVolunteerSignups < ActiveRecord::Migration
  def self.up
    create_table :volunteer_signups do |t|
      t.column :registration_id, :integer
      t.column :contact_id, :integer
      t.column :role, :string
    end
  end

  def self.down
    drop_table :volunteer_signups
  end
end
