class CreatePurchaseHistories < ActiveRecord::Migration
  def self.up
    create_table :purchase_histories do |t|
      t.date :purchase_date
      t.string :user
      t.integer :agent_id
      t.integer :spot_id
      t.integer :price
      t.boolean :is_individual
      t.string :payment_method

      t.timestamps
    end
  end

  def self.down
    drop_table :purchase_histories
  end
end
