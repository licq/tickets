class CreateTeamRates < ActiveRecord::Migration
  def self.up
    create_table :team_rates do |t|
      t.integer :adult_price
      t.integer :child_price
      t.references :agent_price
      t.references :season
      t.references :ticket

      t.timestamps
    end
  end

  def self.down
    drop_table :team_rates
  end
end
