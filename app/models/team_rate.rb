class TeamRate < ActiveRecord::Base
  belongs_to :season
  belongs_to :agent_price
  belongs_to :ticket
  validates_uniqueness_of :agent_price_id, :scope => [:season_id , :ticket_id]

end

# == Schema Information
#
# Table name: team_rates
#
#  id             :integer(4)      not null, primary key
#  adult_price    :integer(4)
#  child_price    :integer(4)
#  agent_price_id :integer(4)
#  season_id      :integer(4)
#  ticket_id      :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#

