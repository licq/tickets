class CreateAgents < ActiveRecord::Migration
  def self.up
    create_table :agents do |t|
      t.string :name
      t.text :description
      t.boolean :disabled, :default => false, :null => false
      t.timestamps
    end

    add_index :agents, :name, :unique => true

  end

  def self.down
    drop_table :agents
  end
end
