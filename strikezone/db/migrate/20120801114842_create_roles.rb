class CreateRoles < ActiveRecord::Migration
  def up
    create_table :roles do |t|
      t.integer :user_id, :null => false
      t.integer :team_id, :null => false
      t.string :name, :default => "Manager"
    end
  end

  def down
    drop_table :roles
  end
end
