class CreateSpots < ActiveRecord::Migration
  def self.up
    create_table :spots do |t|
      t.string :name
      t.string :code
      t.text :description
      t.timestamps
    end

    add_index :spots, :name, :unique => true
    add_index :spots, :code, :unique => true
  end

  def self.down
    drop_table :spots
  end
end
