class AddAlipayConfigToSpots < ActiveRecord::Migration
  def self.up
    add_column :spots, :account, :string
    add_column :spots, :email, :string
    add_column :spots, :key, :string
  end

  def self.down
    remove_column :spots, :key
    remove_column :spots, :email
    remove_column :spots, :account
  end
end
