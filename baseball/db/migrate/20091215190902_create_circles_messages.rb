class CreateCirclesMessages < ActiveRecord::Migration
  def self.up
    create_table :circles_messages do |t|
      t.column :contact_id, :integer, :null => false
      t.column :subject, :string
      t.column :body, :text
      t.column :sent, :datetime
      t.column :important, :boolean
    end
  end

  def self.down
    drop_table :circles_messages
  end
end
