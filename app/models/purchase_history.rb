#encoding: utf-8
class PurchaseHistory < ActiveRecord::Base
  default_scope order('id desc')
  validates_presence_of :purchase_date
  validates_presence_of :user
  validates_presence_of :agent_id
  validates_presence_of :spot_id
  validates_presence_of :price
  validates_presence_of :payment_method

  has_many :reservations
  belongs_to :spot
  belongs_to :agent

  def in_out_for_spot
    self.payment_method == "poa" ? "应付" : "应收"
  end

  def in_out_for_agent
    self.payment_method == "poa" ? "应收" : "应付"
  end

  def ticket_type
    self.is_individual? ? "散客票" : "团队票"
  end

  def self.from_spot(flag)
    if flag
      where(:payment_method => "poa")
    else
      where(:payment_method => "prepay")
    end
  end

  search_methods :from_spot
end
