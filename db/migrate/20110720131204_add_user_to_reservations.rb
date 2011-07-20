class AddUserToReservations < ActiveRecord::Migration
  def self.up
    add_column :reservations, :user_id, :integer
    Reservation.all.each do |r|
      r.user = r.agent.admin
      r.save
    end
  end

  def self.down
    remove_column :reservations, :user_id
  end
end
