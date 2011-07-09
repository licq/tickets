class AddNoteToReservations < ActiveRecord::Migration
  def self.up
    add_column :reservations, :note, :text
  end

  def self.down
    remove_column :reservations, :note
  end
end
