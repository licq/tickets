class CreateTimespans < ActiveRecord::Migration
  def self.up
    create_table :timespans do |t|
      t.date :from
      t.date :to
      t.references :season

      t.timestamps
    end
  end

  def self.down
    drop_table :timespans
  end
end
