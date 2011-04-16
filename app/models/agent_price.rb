class AgentPrice < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true
  belongs_to :spot
  has_many :individual_rates, :dependent => :delete_all
  has_many :team_rates, :dependent => :delete_all
  accepts_nested_attributes_for :team_rates , :individual_rates

  def team_rate_for(season_name, ticket_name)
    selected_rates = team_rates.select { |team_rate| team_rate.season.name == season_name}
    selected_rates1 = selected_rates.select { |team_rate| team_rate.ticket.name == ticket_name}
    selected_rates1.empty? ? nil : selected_rates1[0]
  end

  def individual_rate_for(season_name, ticket_name)
    selected_rates = individual_rates.select { |individual_rate| individual_rate.season.name == season_name }
    selected_rates1 = selected_rates.select { |individual_rate| individual_rate.ticket.name == ticket_name}
    selected_rates1.empty? ? nil : selected_rates1[0]
  end


end
