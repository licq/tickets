class CreateAgentPrices < ActiveRecord::Migration
  def self.up
    create_table :agent_prices do |t|
      t.references :spot
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :agent_prices
  end
end
