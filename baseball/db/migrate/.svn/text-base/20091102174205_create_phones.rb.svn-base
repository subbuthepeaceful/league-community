class CreatePhones < ActiveRecord::Migration
  def self.up
    create_table :phones do |t|
      t.column :phone_number, :string
      t.column :phone_type, :string
      t.column :preferred, :boolean, :default => false
      t.column :contact_id, :integer
    end
  end

  def self.down
    drop_table :phones
  end
end
