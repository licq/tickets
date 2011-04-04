class AddReferencesToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.references :spot
      #t.referneces :agent
    end
  end

  def self.down
  end
end
