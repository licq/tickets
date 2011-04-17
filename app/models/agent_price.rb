class AgentPrice < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true
  belongs_to :spot
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
        individual_rate.ticket == ticket}
    selected_rates.empty? ? nil : selected_rates[0]
  end


end
