class AddNameAndTypeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :type, :string
  end

  def self.down
    remove_column :users, :type
    remove_column :users, :name
  end
end
