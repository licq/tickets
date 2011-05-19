class Reservation < ActiveRecord::Base

  default_scope order('id desc')
  belongs_to :spot
  belongs_to :agent

  validates :contact, :presence => true
  validates :phone, :presence => true
  validates :spot_id, :presence => true

end
