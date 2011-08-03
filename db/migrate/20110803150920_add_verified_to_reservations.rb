class AddVerifiedToReservations < ActiveRecord::Migration
  def self.up
    add_column :reservations, :verified, :boolean, :default => false
  end

  def self.down
    remove_column :reservations, :verified
  end
end
