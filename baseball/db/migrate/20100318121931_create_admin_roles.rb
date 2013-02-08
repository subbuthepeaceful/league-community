class CreateAdminRoles < ActiveRecord::Migration
  def self.up
    create_table :admin_roles do |t|
      t.column :contact_id, :integer, :null => false
      t.column :admin_classification, :string
      t.column :admin_instance, :integer
      t.column :role_title, :string
    end
  end

  def self.down
    drop_table :admin_roles
  end
end
