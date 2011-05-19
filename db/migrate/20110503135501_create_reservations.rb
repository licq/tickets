class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.string :no
      t.references :agent
      t.references :spot
      t.string :ticket_name
      t.integer :child_sale_price
      t.integer :child_purchase_price
      t.integer :adult_sale_price
      t.integer :adult_purchase_price
      t.integer :adult_price
      t.integer :child_price
      t.integer :child_ticket_number, :default => "0"
      t.integer :adult_ticket_number, :default => "1"
      t.date :date
      t.string :type
      t.string :contact
      t.string :phone
      t.integer :total_price
      t.integer :total_purchase_price
      t.boolean :paid
      t.integer :adult_true_ticket_number
      t.integer :child_true_ticket_number
      t.timestamps
    end
  end

  def self.down
    drop_table :reservations
  end
end
