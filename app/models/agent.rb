class Agent < ActiveRecord::Base
  paginates_per 10

  validates :name, :presence => true, :uniqueness => true
  validates :operator, :presence => true
  validates_associated :operator

  has_one :operator, :class_name => "AgentOperator"
  accepts_nested_attributes_for :operator
end
