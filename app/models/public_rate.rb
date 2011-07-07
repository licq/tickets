class PublicRate < ActiveRecord::Base
  belongs_to :season
  belongs_to :ticket

  validates_uniqueness_of :ticket_id, :scope => :season_id
  validates :adult_price, :presence => true
  validates :child_price, :presence => true
end
