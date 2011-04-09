class CreateSeasons < ActiveRecord::Migration
  def self.up
    create_table :seasons do |t|
      t.string :name
      t.references :spot
      t.timestamps
    end
  end

  def self.down
    drop_table :seasons
  end
end
