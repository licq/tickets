class Rfp < ActiveRecord::Base
  validates_presence_of :spot_id
  validates_presence_of :agent_id
  validates_presence_of :agent_price_id, :if => Proc.new { |rfp| rfp.from_spot? }

  belongs_to :agent
  belongs_to :agent_price
  belongs_to :spot
end
