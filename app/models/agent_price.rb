class AgentPrice < ActiveRecord::Base

  belongs_to :spot
  belongs_to :season
  has_many :individual_rates, :dependent => :delete_all
  has_many :team_rates,  :dependent => :delete_all

  def team_rate_for(season_name)
    selected_rates = team_rates.select { |team_rate| team_rate.season.name == season_name }
    selected_rates.empty? ? nil : selected_rates[0]
    end

  def individual_rate_for(season_name)
    selected_rates = individual_rates.select { |individual_rate| individual_rate.season.name == season_name }
    selected_rates.empty? ? nil : selected_rates[0]
  end


end
