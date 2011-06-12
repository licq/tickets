#coding: utf-8
class Reservation < ActiveRecord::Base

  default_scope order('id desc')
  scope :exclude_canceled, where(:status.ne => "canceled")
  belongs_to :spot
  belongs_to :agent

  validates :contact, :presence => true
  validates :phone, :presence => true
  validates :spot_id, :presence => true
  validates_numericality_of :adult_ticket_number, :greater_than => 0, :message => "成人票数量不能为0"

  after_create :set_no

  def self.with_status(status)
    case status
      when "confirmed"
        where(:status => status, :date.gte => Date.today)
      when "outdated"
        where(:status => "confirmed", :date.lt => Date.today)
      else
        where(:status => status)
    end

  end

  search_methods :with_status

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
    is_confirmed?
  end

  def can_cancel
    is_confirmed?
  end

  def is_confirmed?
    self.status == "confirmed" && self.date >= Date.today
  end

  def self.search_for_today(search)
    reservations_for_today_and_confirmed = where({:date.eq => Date.today, :status.eq => :confirmed})
    if search
      reservations_for_today_and_confirmed = reservations_for_today_and_confirmed.where((:phone.matches % "#{search}%" | :contact.matches % "%#{search}%" | :no.matches % "%#{search}%"))
    end
    reservations_for_today_and_confirmed
  end

  def self.day_between(start_date, end_date)
    where(:created_at => start_date..end_date)
  end

  def self.sum_between(start_time, end_time)
    individual_sum = select('count(1) as count_sum, sum(adult_ticket_number) as adult_ticket_sum, sum(child_ticket_number) as child_ticket_sum,
                sum(adult_ticket_number * adult_sale_price + child_ticket_number * child_sale_price) as price_sum').where(:created_at => start_time..end_time,:type => "IndividualReservation")
    team_sum = select('count(1) as count_sum, sum(adult_ticket_number) as adult_ticket_sum, sum(child_ticket_number) as child_ticket_sum,
                sum(adult_ticket_number * adult_price + child_ticket_number * child_price) as price_sum').where(:created_at => start_time..end_time,:type => "TeamReservation")

    return individual_sum[0].count_sum+team_sum[0].count_sum, individual_sum[0].adult_ticket_sum+team_sum[0].adult_ticket_sum,
           individual_sum[0].child_ticket_sum+individual_sum[0].child_ticket_sum, individual_sum[0].price_sum+team_sum[0].price_sum
  end

end
