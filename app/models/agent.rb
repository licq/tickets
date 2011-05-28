class Agent < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true
  validates :operator, :presence => true
  validates_associated :operator

  has_one :operator, :class_name => "AgentOperator"
  accepts_nested_attributes_for :operator
  has_many :rfps
  has_many :reservations

  def self.not_connected_with_spot(spot)
    select('agents.*').
        joins("left join rfps on agents.id = rfps.agent_id and rfps.status!='r' and rfps.spot_id = #{spot.id}").
        where("rfps.agent_id is null and agents.disabled = 'f'")
  end
end
