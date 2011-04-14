class PublicRate < ActiveRecord::Base
  belongs_to :season
  belongs_to :ticket

  validates_uniqueness_of :ticket_id, :scope => :season_id
end
