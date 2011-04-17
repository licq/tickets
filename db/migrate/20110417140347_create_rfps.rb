class CreateRfps < ActiveRecord::Migration
  def self.up
    create_table :rfps do |t|
      t.references :agent
      t.references :spot
      t.references :agent_price
      t.string :status, :limit => 1,:default => "a"
      t.boolean :from_spot, :default=> false
      t.timestamps
    end
  end

  def self.down
    drop_table :rfps
  end
end
