class BookTicket < ActiveRecord::Base

  belongs_to :spot
  belongs_to :agent
  belongs_to :city
  belongs_to :ticket

  validates :linkman, :presence => true
  validates :linktel, :presence => true
  validates :spot_id, :presence => true
  validates :city_id, :presence => true


end
