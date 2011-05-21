#coding: utf-8
class Reservation < ActiveRecord::Base

  default_scope order('id desc')
  belongs_to :spot
  belongs_to :agent

  validates :contact, :presence => true
  validates :phone, :presence => true
  validates :spot_id, :presence => true
  validates_numericality_of :adult_ticket_number, :greater_than => 0, :message => "成人票数量不能为0"

  def status_name
    case self.status
      when 'confirmed'
        '已确认'
      when 'canceled'
        '已取消'
    end
  end

  def can_edit
    return true if self.status == 'confirmed'
    false
  end

  def can_cancel
    return true if self.status == 'confirmed'
    false
  end

end
