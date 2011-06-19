class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.string :name
      t.string :url
      t.references :menu_group
      t.integer :seq
    end
  end

  def self.down
    drop_table :menus
  end
end
