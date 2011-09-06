class Agent < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true
  validates :admin, :presence => true
  validates_associated :admin

  has_one :admin, :class_name => "AgentAdmin"
  has_many :operators, :class_name => "AgentOperator"
  accepts_nested_attributes_for :admin
  has_many :rfps
  has_many :reservations
  has_many :roles, :as => :roleable
  has_many :received_messages, :as => :message_to, :class_name => "Message"
  has_many :sent_messages, :as => :message_from, :class_name => "Message"
  has_many :purchase_histories

  def unread_messages
    received_messages.unread
  end

  def self.not_connected_with_spot(spot)
    select('agents.*').
        joins("left join rfps on agents.id = rfps.agent_id and rfps.status!='r' and rfps.spot_id = #{spot.id}").
        where("rfps.agent_id is null and agents.disabled = 'f'")
  end

  def self.applied_for_spot(spot)
    joins(:rfps).where({:disabled => false}, :rfps => {:spot_id => spot.id, :status => 'a', :from_spot => false})
  end

end

# == Schema Information
#
# Table name: agents
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  description      :text
#  disabled         :boolean(1)      default(FALSE), not null
#  created_at       :datetime
#  updated_at       :datetime
#  address          :string(255)
#  business_contact :string(255)
#  business_phone   :string(255)
#  finance_contact  :string(255)
#  finance_phone    :string(255)
#

