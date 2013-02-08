class AddProgramVariantToHubs < ActiveRecord::Migration
  def self.up
    add_column :hubs, :program_variant, :string
  end

  def self.down
    remove_column :hubs, :program_variant
  end
end
