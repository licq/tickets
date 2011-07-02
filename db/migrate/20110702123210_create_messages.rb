class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.references :message_from, :polymorphic => true
      t.references :message_to, :polymorphic => true
      t.string :content
      t.boolean :read, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
