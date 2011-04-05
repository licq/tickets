class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :code
      t.string :name
      t.string :pinyin

      t.timestamps
    end

    add_index :cities, :code, :unique => true
    add_index :cities, :name, :unique => true
  end

  def self.down
    drop_table :cities
  end
end
