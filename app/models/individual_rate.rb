class IndividualRate < ActiveRecord::Base
  belongs_to :season
  belongs_to :agent_price
  belongs_to :ticket
  validates_uniqueness_of :agent_price_id, :scope => [:season_id, :ticket_id]
end
