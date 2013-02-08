class AddTaxIdToHub < ActiveRecord::Migration
  def self.up
    add_column :hubs, :tax_id, :string
  end

  def self.down
    remove_column :hubs, :tax_id
  end
end
