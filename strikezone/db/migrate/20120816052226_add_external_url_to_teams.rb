class AddExternalUrlToTeams < ActiveRecord::Migration
  def up
    add_column :teams, :external_url, :string
  end

  def down
    remove_column :teams, :external_url
  end
end
