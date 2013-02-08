class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.column :title, :string, :limit => 8
      t.column :first_name, :string, :limit => 24
      t.column :last_name, :string, :limit => 24
      t.column :date_of_birth, :datetime
      t.column :member_since, :datetime
    end
  end

  def self.down
    drop_table :participants
  end
end
