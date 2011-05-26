class AddOtherInformationToSpots < ActiveRecord::Migration
  def self.up
    add_column :spots, :address, :string
    add_column :spots, :traffic, :text
    add_column :spots, :business_contact, :string
    add_column :spots, :business_phone, :string
    add_column :spots, :finance_contact, :string
    add_column :spots, :finance_phone, :string
  end

  def self.down
    remove_column :spots, :address
    remove_column :spots, :traffic
    remove_column :spots, :business_contact
    remove_column :spots, :business_phone
    remove_column :spots, :finance_contact
    remove_column :spots, :finance_phone
  end
end
