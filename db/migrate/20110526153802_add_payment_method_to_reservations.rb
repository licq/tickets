class AddPaymentMethodToReservations < ActiveRecord::Migration
  def self.up
    add_column :reservations, :payment_method, :string
  end

  def self.down
    remove_column :reservations, :payment_method
  end
end
