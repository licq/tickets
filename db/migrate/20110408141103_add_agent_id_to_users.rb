class AddAgentIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :agent_id, :integer
  end

  def self.down
    remove_column :users, :agent_id
  end
end
