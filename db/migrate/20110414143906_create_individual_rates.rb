class CreateIndividualRates < ActiveRecord::Migration
  def self.up
    create_table :individual_rates do |t|
      t.integer :child_sale_price
      t.integer :child_purchase_price
      t.integer :adult_sale_price
      t.integer :adult_purchase_price
      t.references :agent_price
      t.references :season
      t.references :ticket
      t.timestamps
    end
  end

  def self.down
    drop_table :individual_rates
  end
end
