class AgentAdmin < User
  belongs_to :agent

  def menu_groups
    MenuGroup.includes(:menus).where(:category => 'agent')
  end

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