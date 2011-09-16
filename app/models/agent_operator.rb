#coding:utf-8
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

  def spot_price_name
    case self.spot_price_cat
      when "all"
        "全部"
      when "team"
        "团队价"
      when "individual"
        "散客价"
    end
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

