class AddPurchaseHistoryIdToReservations < ActiveRecord::Migration
  def self.up
    add_column :reservations, :purchase_history_id, :integer
    Reservation.update_all(:paid => false)
  end

  def self.down
    remove_column :reservations, :purchase_history_id
  end
end
