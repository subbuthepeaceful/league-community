class CreateSponsoredOptions < ActiveRecord::Migration
  def self.up
    create_table :sponsored_options do |t|
      t.column :sponsor_id, :integer
      t.column :sponsorship_option_id, :integer
      t.column :amount, :integer
      t.column :additional_info, :text
    end
  end

  def self.down
    drop_table :sponsored_options
  end
end
