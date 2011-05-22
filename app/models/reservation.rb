#coding: utf-8
class Reservation < ActiveRecord::Base

  default_scope order('id desc')
  belongs_to :spot
  belongs_to :agent

  validates :contact, :presence => true
  validates :phone, :presence => true
  validates :spot_id, :presence => true
  validates_numericality_of :adult_ticket_number, :greater_than => 0, :message => "成人票数量不能为0"

  after_create :set_no

  def set_no
    self.no = (100000 + self.id).to_s
    self.save
  end

  def status_name
    case self.status
      when 'confirmed'
        if self.date >= Date.today
          '已确认'
        else
          '已过期'
        end
      when 'canceled'
        '已取消'
      when 'checkedin'
        '已入园'
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

  def self.search_for_today(search)
    reservations_for_today_and_confirmed = where({:date.eq => Date.today, :status.eq => :confirmed})
    if search
      reservations_for_today_and_confirmed.where((:phone.matches % "#{search}%" | :contact.matches % "%#{search}%" | :no.matches % "%#{search}%"))
    end
    reservations_for_today_and_confirmed
  end

end
