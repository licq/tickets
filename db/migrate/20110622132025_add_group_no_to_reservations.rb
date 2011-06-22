class AddGroupNoToReservations < ActiveRecord::Migration
  def self.up
    add_column :reservations, :group_no, :string
  end

  def self.down
    remove_column :reservations, :group_no
  end
end
