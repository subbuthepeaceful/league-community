class CreateSponsorshipOptions < ActiveRecord::Migration
  def self.up
    create_table :sponsorship_options do |t|
      t.column :hub_id, :integer
      t.column :group, :string
      t.column :name, :string
      t.column :description, :string
      t.column :graphic_file_name, :string
      t.column :graphic_file_type, :string
      t.column :graphic_file_size, :integer
      t.column :amount, :string
      t.column :primary, :boolean
    end
  end

  def self.down
    drop_table :sponsorship_options
  end
end
