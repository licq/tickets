class AgentOperator < User

  belongs_to :agent
  validates_presence_of :role

  def is_spot_user
    false
  end

  def is_agent_user
    true
  end

  def is_system_user
    false
  end

end