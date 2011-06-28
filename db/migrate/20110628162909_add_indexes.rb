class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :cities, :pinyin
    add_index :tickets, :name
    add_index :seasons, :name
    add_index :menus, :menu_group_id
    add_index :users, :deleted
    add_index :reservations, :no, :unique => true
    add_index :reservations, :agent_id
    add_index :reservations, :spot_id
    add_index :reservations, :date
    add_index :reservations, :contact
    add_index :reservations, :phone
    add_index :reservations, :created_at
    add_index :rfps, :agent_id
    add_index :rfps, :spot_id
    add_index :rfps, :agent_price_id
  end

  def self.down
    remove_index :cities, :pinyin
    remove_index :tickets, :name
    remove_index :seasons, :name
    remove_index :menus, :menu_group_id
    remove_index :users, :deleted
    remove_index :reservations, :no
    remove_index :reservations, :agent_id
    remove_index :reservations, :spot_id
    remove_index :reservations, :date
    remove_index :reservations, :contact
    remove_index :reservations, :phone
    remove_index :reservations, :created_at
    remove_index :rfps, :agent_id
    remove_index :rfps, :spot_id
    remove_index :rfps, :agent_price_id    
  end
end
