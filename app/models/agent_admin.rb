class AgentAdmin < User
  belongs_to :agent

  def menu_groups
    MenuGroup.includes(:menus).where(:category => 'agent')
  end

end