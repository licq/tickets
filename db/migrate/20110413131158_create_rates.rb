class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
      t.references :season
      t.integer :adult_price
      t.integer :child_price
      t.references :ratable, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :rates
  end
end
