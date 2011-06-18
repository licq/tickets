class AddBookPriceToReservations < ActiveRecord::Migration
  def self.up
    add_column :reservations, :book_price, :integer
    add_column :reservations, :book_purchase_price, :integer
  end

  def self.down
    remove_column :reservations, :book_price
    remove_column :reservations, :book_purchase_price
  end
end
