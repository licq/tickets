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

# == Schema Information
#
# Table name: users
#
#  id             :integer(4)      not null, primary key
#  username       :string(255)
#  email          :string(255)
#  password_hash  :string(255)
#  password_salt  :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  name           :string(255)
#  type           :string(255)
#  spot_id        :integer(4)
#  agent_id       :integer(4)
#  role_id        :integer(4)
#  deleted        :boolean(1)      default(FALSE)
#  spot_price_cat :string(255)     default("team")
#

