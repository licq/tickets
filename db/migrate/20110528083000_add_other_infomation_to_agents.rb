class AddOtherInfomationToAgents < ActiveRecord::Migration
  def self.up
    add_column :agents, :address, :string
    add_column :agents, :business_contact, :string
    add_column :agents, :business_phone, :string
    add_column :agents, :finance_contact, :string
    add_column :agents, :finance_phone, :string
  end

  def self.down
    remove_column :agents, :address
    remove_column :agents, :business_contact
    remove_column :agents, :business_phone
    remove_column :agents, :finance_contact
    remove_column :agents, :finance_phone
  end
end
