class AddPaymentMethodToReservations < ActiveRecord::Migration
  def self.up
    add_column :reservations, :team_payment_method, :string
    add_column :reservations, :individual_payment_method, :string
  end

  def self.down
    remove_column :reservations, :team_payment_method
    remove_column :reservations, :individual_payment_method
  end
end
