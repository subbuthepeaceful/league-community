class CreateCircleOptions < ActiveRecord::Migration
  def self.up
    create_table :circle_options do |t|
      t.column :hub_id, :integer, :null => false
      t.column :option_name, :string
      t.column :option_value, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :circle_options
  end
end
