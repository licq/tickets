#coding: utf-8

class Spot < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :code, :presence => true, :uniqueness => true
  validates_associated :admin
  validates_presence_of :admin, :on => :create, :message => "必须设置管理员"
  validates :cities, :presence => {:message => "至少选择一个城市"}, :on => :save

  has_many :users
  has_one :admin, :class_name => 'SpotAdmin', :dependent => :delete
  has_many :operators, :class_name => 'SpotOperator'
  has_and_belongs_to_many :cities
  has_many :seasons
  has_many :timespans, :through => :seasons
  has_many :tickets
  has_many :public_rates,:through => :tickets
  has_many :agent_prices
  has_many :rfps
  has_many :reservations
  has_many :roles, :as => :roleable
  has_many :received_messages, :as => :message_to,:class_name => "Message"
  has_many :sent_messages, :as => :message_from,:class_name => "Message"

  has_many :purchase_histories
  attr_reader :city_tokens

  accepts_nested_attributes_for :admin

  def city_tokens=(ids)
    self.city_ids = ids.split(",")
  end

  def unread_messages
    received_messages.unread
  end

  def self.not_connected_with_agent(agent)
    select('spots.*').
        joins("left join rfps on spots.id = rfps.spot_id and rfps.status!='r' and rfps.agent_id = #{agent.id}").
        where("rfps.spot_id is null and spots.disabled = 'f'")
  end

  def city_names
    self.cities.map(&:name).join(",")
  end

  def self.applied_for_agent(agent)
    joins(:rfps).where({:disabled => false},:rfps => {:agent_id => agent.id, :status => 'a', :from_spot => false})
  end

  def public_rates_complete?
    public_rates.size == seasons.size * tickets.size
  end

  def can_net?
    self.account.present? && self.key.present? && self.email.present?
  end

  def available_payment_methods
    if can_net?
      [["门口现付", "poa"], ["挂账", "prepay"],["预付","net"]]
    else
      [["门口现付", "poa"], ["挂账", "prepay"]]
    end
  end


end

# == Schema Information
#
# Table name: spots
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  code             :string(255)
#  description      :text
#  created_at       :datetime
#  updated_at       :datetime
#  disabled         :boolean(1)      default(FALSE), not null
#  address          :string(255)
#  traffic          :text
#  business_contact :string(255)
#  business_phone   :string(255)
#  finance_contact  :string(255)
#  finance_phone    :string(255)
#  account          :string(255)
#  email            :string(255)
#  key              :string(255)
#

