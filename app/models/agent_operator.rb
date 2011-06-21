class AgentOperator < User

  belongs_to :agent
  validates_presence_of :role

end