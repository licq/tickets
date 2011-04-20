#coding: utf-8
class Rfp < ActiveRecord::Base
  validates_presence_of :spot_id
  validates_presence_of :agent_id
  validates_presence_of :agent_price_id, :if => Proc.new { |rfp| rfp.from_spot? }
  validates_inclusion_of :status, :in=> ['a','r','c']
  validates_uniqueness_of :spot_id , :scope => [:agent_id], :if => Proc.new { |rfp| rfp.status=='a' }, :message => "已经存在景区与旅行社之间的关联"

  belongs_to :agent
  belongs_to :agent_price
  belongs_to :spot

  scope :connected, where(:status => "c")
  scope :applied_by_spot, where(:status => "a", :from_spot => true)
  scope :applied_by_agent, where(:status => "a", :from_spot => false)

end
