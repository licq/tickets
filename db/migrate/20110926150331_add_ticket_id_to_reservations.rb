class AddTicketIdToReservations < ActiveRecord::Migration
  def self.up
    add_column :reservations, :ticket_id, :integer
    Reservation.all.each do |r|
      r.ticket = Ticket.where(:spot_id => r.spot_id, :name => r.ticket_name).first
      r.save
    end
  end

  def self.down
    remove_column :reservations, :ticket_id
  end
end
