class AddPaymentMethodToRfps < ActiveRecord::Migration
  def self.up
    add_column :rfps, :team_payment_method, :string
    add_column :rfps, :individual_payment_method, :string
  end

  def self.down
    remove_column :rfps, :team_payment_method
    remove_column :rfps, :individual_payment_method
  end
end
