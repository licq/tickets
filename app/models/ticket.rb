class Ticket < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  belongs_to :spot
  has_many :rates, :as => :ratable, :dependent => :delete_all
  accepts_nested_attributes_for :rates

  def rate_for(season_name)
    selected_rates = rates.select { |rate| rate.season.name == season_name }
    selected_rates.empty? ? nil : selected_rates[0]
  end
end
