class CreateBookTickets < ActiveRecord::Migration
  def self.up
    create_table :book_tickets do |t|
      t.references :agent
      t.references :spot
      t.references :city
      t.references :ticket
      t.integer :child_sale_price
      t.integer :child_purchase_price
      t.integer :adult_sale_price
      t.integer :adult_purchase_price
      t.integer :adult_price
      t.integer :child_price
      t.integer :child_ticket_number, :default => "0"
      t.integer :adult_ticket_number, :default => "1"
      t.date :date
      t.boolean :is_team
      t.string :linkman
      t.string :linktel
      t.integer :total_price
      t.timestamps
    end
  end

  def self.down
    drop_table :book_tickets
  end
end
