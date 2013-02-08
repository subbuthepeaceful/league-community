class CreateGameStatistics < ActiveRecord::Migration
  def self.up
    create_table :game_statistics do |t|
      t.column :game_report_id, :integer, :null => false
      t.column :participant_id, :integer, :null => false
      t.column :statistic_name, :string
      t.column :statistic_value, :string
    end
  end

  def self.down
    drop_table :game_statistics
  end
end
