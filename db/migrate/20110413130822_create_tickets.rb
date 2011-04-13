class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.string :name
      t.references :spot
      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
