class AddFullCircleDomainToHub < ActiveRecord::Migration
  def self.up
    add_column :hubs, :full_circles_domain, :string, :default => nil
  end

  def self.down
    remove_column :hubs, :full_circles_domain
  end
end
