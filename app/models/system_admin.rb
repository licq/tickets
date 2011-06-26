# == Schema Information
# Schema version: 20110405152243
#
# Table name: users
#
#  id            :integer         not null, primary key
#  username      :string(255)
#  email         :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  name          :string(255)
#  type          :string(255)
#  spot_id       :integer
#

class SystemAdmin < User

  def menu_groups
    MenuGroup.includes(:menus).where(:category => 'system')
  end

  def is_spot_user
    false
  end

  def is_agent_user
    false
  end

  def is_system_user
    true
  end

end
