class CreateCitiesSpots < ActiveRecord::Migration
  def self.up
    create_table :cities_spots, :id => false do |t|
      t.references :city
      t.references :spot
    end
  end

  def self.down
     drop_table :cities_spots
  end
end
