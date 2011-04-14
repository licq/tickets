class CreatePublicRates < ActiveRecord::Migration
  def self.up
    create_table :public_rates do |t|
      t.references :season
      t.integer :adult_price
      t.integer :child_price
      t.references :ticket
      t.timestamps
    end
  end

  def self.down
    drop_table :public_rates
  end
end
