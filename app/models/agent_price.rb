class AgentPrice < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true
  belongs_to :spot
  has_many :rfps
  has_many :individual_rates, :dependent => :delete_all
  has_many :team_rates, :dependent => :delete_all
  accepts_nested_attributes_for :team_rates, :individual_rates

  def team_rate_for(season, ticket)
    selected_rates = team_rates.select { |team_rate| team_rate.season == season &&
        team_rate.ticket == ticket }
    selected_rates.empty? ? nil : selected_rates[0]
  end

  def individual_rate_for(season, ticket)
    selected_rates = individual_rates.select { |individual_rate| individual_rate.season == season &&
        individual_rate.ticket == ticket }
    selected_rates.empty? ? nil : selected_rates[0]
  end

  def self.connected_for_agent(agent_id)
    AgentPrice.joins(:rfps).where(:rfps => {:agent_id => agent_id, :status => 'c'})
  end

  def price_for(date)
    individual_rates = IndividualRate.joins(:season => :timespans).
        where(:individual_rates => {:agent_price_id => self.id},
              :timespans => {:from_date.lte => date, :to_date.gte => date})
    team_rates = TeamRate.joins(:season => :timespans).
        where(:team_rates => {:agent_price_id => self.id},
              :timespans => {:from_date.lte => date, :to_date.gte => date})
    ticket_ids = individual_rates.map(&:ticket_id) | team_rates.map(&:ticket_id)
    result = {}
    ticket_ids.each do |ticket_id|
      result[ticket_id] =
          {:individual_rate => individual_rates.select { |r| r.ticket_id == ticket_id }[0],
           :team_rate => team_rates.select { |r| r.ticket_id == ticket_id }[0]
          }
    end
    result
  end
end
