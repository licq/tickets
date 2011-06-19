class CreateMenusRoles < ActiveRecord::Migration
  def self.up
    create_table :menus_roles, :id => false do |t|
      t.references :role
      t.references :menu
    end
  end

  def self.down
    drop_table :menus_roles
  end
end
