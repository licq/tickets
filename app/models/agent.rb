class Agent < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :operator, :presence => true
  validates_associated :operator

  has_one :operator, :class_name => "AgentOperator"
end
