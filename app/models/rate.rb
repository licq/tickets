class Rate < ActiveRecord::Base
  belongs_to :season
  belongs_to :ratable, :polymorphic => true

  validates_uniqueness_of :season_id, :scope => [:ratable_id, :ratable_type]
end
