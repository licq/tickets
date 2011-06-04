#coding: utf-8
class Rfp < ActiveRecord::Base
  default_scope order('id desc')
  validates_presence_of :spot_id, :message => "必须选择一个景区"
  validates_presence_of :agent_id, :message => "必须选择一个旅行社"
  validates_presence_of :agent_id, :scope =>[:spot_id], :message => "已经存在与旅行社的关联"
  validates_presence_of :spot_id, :scope =>[:agent_id], :message => "已经存在与景区的关联"
  validates_presence_of :agent_price_id, :if => Proc.new { |rfp| rfp.from_spot? }, :message => "必须选择一个旅行社价格"
  validates_presence_of :team_payment_method, :if => Proc.new { |rfp| rfp.from_spot? }, :message => "必须选择团队票支付方式"
  validates_presence_of :individual_payment_method, :if => Proc.new { |rfp| rfp.from_spot? }, :message => "必须选择散客票支付方式"
  validates_inclusion_of :status, :in=> ['a', 'r', 'c']


  belongs_to :agent
  belongs_to :agent_price
  belongs_to :spot

  scope :connected, where(:status => "c")
  scope :applied_by_agent, where(:status => "a", :from_spot => false)

  def self.delete_by_spot_id_and_agent_id(spot_id,agent_id)
    Rfp.delete_all "spot_id = #{spot_id} and agent_id = #{agent_id}"
  end

end
