class AddDisabledToSpots < ActiveRecord::Migration
  def self.up
    add_column :spots, :disabled, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :spots, :disabled
  end
end
