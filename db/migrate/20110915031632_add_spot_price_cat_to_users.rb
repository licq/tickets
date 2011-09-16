class AddSpotPriceCatToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :spot_price_cat, :string,:default => 'all'
  end

  def self.down
    remove_column :users, :spot_price_cat
  end
end
