class CreateAuthorizedUsers < ActiveRecord::Migration
  def up
    create_table :authorized_users do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :email, :null => false
    end

    create_table :authorized_users_teams, :id => false do |t|
      t.integer :authorized_user_id, :null => false
      t.integer :team_id, :null => false
    end
  end

  def down
    drop_table :authorized_users_teams
    drop_table :authorized_users
  end
end
