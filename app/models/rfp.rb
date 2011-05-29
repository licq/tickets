#coding: utf-8
class Rfp < ActiveRecord::Base
  default_scope order('id desc')
  validates_presence_of :spot_id, :message => "必须选择一个景区"
  validates_presence_of :agent_id, :message => "必须选择一个旅行社"
  validates_presence_of :agent_price_id, :if => Proc.new { |rfp| rfp.from_spot? }, :message => "必须选择一个旅行社价格"
  validates_presence_of :team_payment_method, :if => Proc.new { |rfp| rfp.from_spot? }, :message => "必须选择团队票支付方式"
  validates_presence_of :individual_payment_method, :if => Proc.new { |rfp| rfp.from_spot? }, :message => "必须选择散客票支付方式"
  validates_inclusion_of :status, :in=> ['a', 'r', 'c']

  validate :agent_id_and_spot_id_must_be_unique_when_status_not_rejected, :on => :create

  def agent_id_and_spot_id_must_be_unique_when_status_not_rejected
    return if agent_id.blank?
    return if spot_id.blank?
    num_duplicates = self.class.count(:conditions => ["spot_id = ? AND agent_id = ? AND status != 'r'", self.spot_id, self.agent_id])
    if num_duplicates > 0
      errors.add(:spot_id, "已经存在与景区的关联")
      errors.add(:agent_id, "已经存在与旅行社的关联")
    end
  end

  belongs_to :agent
  belongs_to :agent_price
  belongs_to :spot

  scope :connected, where(:status => "c")
  scope :applied_by_spot, where(:status => "a", :from_spot => true)
  scope :applied_by_agent, where(:status => "a", :from_spot => false)
end
