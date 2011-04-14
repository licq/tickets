class Ticket < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  belongs_to :spot
  has_many :public_rates, :dependent => :delete_all
  accepts_nested_attributes_for :public_rates

  def public_rate_for(season_name)
    selected_public_rates = public_rates.select { |public_rate| public_rate.season.name == season_name }
    selected_public_rates.empty? ? nil : selected_public_rates[0]
  end
end
