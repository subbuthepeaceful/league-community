class AddStatusToSponsoredOptions < ActiveRecord::Migration
  def self.up
    add_column :sponsored_options, :status, :string
    add_column :sponsored_options, :payment_reference, :string
  end

  def self.down
    remove_column :sponsored_options, :status
    remove_column :sponsored_options, :payment_reference
  end
end
