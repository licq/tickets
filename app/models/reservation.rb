class Reservation < ActiveRecord::Base

  belongs_to :spot
  belongs_to :agent

  validates :contact, :presence => true
  validates :phone, :presence => true
  validates :spot_id, :presence => true

end
