class Ticket < ActiveRecord::Base
  validates :name, :presence => true
  validates_uniqueness_of :name, :scope => [:spot]


  belongs_to :spot
  has_many :public_rates, :dependent => :delete_all
  has_many :individual_rates, :dependent => :delete_all
  has_many :team_rates, :dependent => :delete_all
  accepts_nested_attributes_for :public_rates

  def public_rate_for(season_name)
    selected_public_rates = public_rates.select { |public_rate| public_rate.season.name == season_name }
    selected_public_rates.empty? ? nil : selected_public_rates[0]
  end
end

# == Schema Information
#
# Table name: tickets
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  spot_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

