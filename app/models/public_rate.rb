class PublicRate < ActiveRecord::Base
  belongs_to :season
  belongs_to :ticket

  validates_uniqueness_of :ticket_id, :scope => :season_id
  validates :adult_price, :presence => true
  validates :child_price, :presence => true
end

# == Schema Information
#
# Table name: public_rates
#
#  id          :integer(4)      not null, primary key
#  season_id   :integer(4)
#  adult_price :integer(4)
#  child_price :integer(4)
#  ticket_id   :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

