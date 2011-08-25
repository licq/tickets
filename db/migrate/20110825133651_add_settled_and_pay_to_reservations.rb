class AddSettledAndPayToReservations < ActiveRecord::Migration
  def self.up
    add_column :reservations, :settled, :boolean
    add_column :reservations, :pay_id, :string
    add_column :reservations, :pay_time, :datetime

    Reservation.update_all(:settled => false)
  end

  def self.down
    remove_column :reservations, :pay_time
    remove_column :reservations, :pay_id
    remove_column :reservations, :settled
  end
end
