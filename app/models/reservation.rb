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

  def self.sum_output_between(start_time, end_time)
    individual_sum = select('count(1) as count_sum, sum(adult_ticket_number) as adult_ticket_sum, sum(child_ticket_number) as child_ticket_sum,
                sum(adult_ticket_number * adult_sale_price + child_ticket_number * child_sale_price) as price_sum').where(:created_at => start_time..end_time, :type => "IndividualReservation")
    team_sum = select('count(1) as count_sum, sum(adult_ticket_number) as adult_ticket_sum, sum(child_ticket_number) as child_ticket_sum,
                sum(adult_ticket_number * adult_price + child_ticket_number * child_price) as price_sum').where(:created_at => start_time..end_time, :type => "TeamReservation")
    is = replace_nil_with_zero(individual_sum[0])
    ts = replace_nil_with_zero(team_sum[0])
    return is.count_sum + ts.count_sum, is.adult_ticket_sum + ts.adult_ticket_sum,
        is.child_ticket_sum + ts.child_ticket_sum, is.price_sum + ts.price_sum
  end

  def self.sum_checkin_between(start_time, end_time)
    reservation_sum = select('count(1) as count_sum, sum(adult_true_ticket_number) as adult_ticket_sum, sum(child_true_ticket_number) as child_ticket_sum,
                sum(total_price) as price_sum').where(:created_at => start_time..end_time, :status => "checkedin")

    rs = replace_nil_with_zero(reservation_sum[0])
    return rs.count_sum, rs.adult_ticket_sum, rs.child_ticket_sum, rs.price_sum
  end


  def self.sum_agent_output_between(start_time, end_time)

    individual_sum = select('agent_id,agents.name as agent_name,count(1) as count_sum, sum(adult_ticket_number) as adult_ticket_sum, sum(child_ticket_number) as child_ticket_sum,
                sum(adult_ticket_number * adult_sale_price + child_ticket_number * child_sale_price) as price_sum').joins(:agent).group(:agent_id).where(:created_at => start_time..end_time, :type => "IndividualReservation").reorder(:agent_id)
    team_sum = select('agent_id,agents.name as agent_name,count(1) as count_sum, sum(adult_ticket_number) as adult_ticket_sum, sum(child_ticket_number) as child_ticket_sum,
                sum(adult_ticket_number * adult_price + child_ticket_number * child_price) as price_sum').joins(:agent).group(:agent_id).where(:created_at => start_time..end_time, :type => "TeamReservation").reorder(:agent_id)
    result_map = {}
    individual_sum.each do |s|
      s = replace_nil_with_zero(s)
      result_map[s.agent_id] = [s.agent_name, s.count_sum, s.adult_ticket_sum, s.child_ticket_sum, s.price_sum]
    end

    team_sum.each do |s|
      s = replace_nil_with_zero(s)
      if result_map.has_key?(s.agent_id)
        t = result_map[s.agent_id]
        result_map[s.agent_id] = [s.agent_name, s.count_sum+t[1], s.adult_ticket_sum+t[2], s.child_ticket_sum+t[3],
                                  s.price_sum+t[4]]
      else
        result_map << [s.agent_name, s.count_sum, s.adult_ticket_sum, s.child_ticket_sum, s.price_sum]
      end
    end

    result_map.values.sort_by { |x, y| x[5]<=>y[5] }
  end

  def self.replace_nil_with_zero(object)
    if object.respond_to?(:count_sum)
      object.count_sum ||= 0
    end
    if object.respond_to?(:adult_ticket_sum)
      object.adult_ticket_sum ||= 0
    end
    if object.respond_to?(:child_ticket_sum)
      object.child_ticket_sum ||= 0
    end
    if object.respond_to?(:price_sum)
      object.price_sum ||= 0
    end
    object
  end

  def self.sum_purchase_with_agents
    prepay_purchase_sum = select('agent_id,agents.name as agent_name,type,payment_method,count(1) as count_sum,
                sum(case when type="IndividualReservation" then total_purchase_price else total_price end) as price_sum').joins(:agent).group(:agent_name, :type, :payment_method).where(:paid => false, :payment_method => 'prepay', :status => "checkedin").reorder(:agent_id)
    poa_purchase_sum = select('agent_id,agents.name as agent_name,type,payment_method,count(1) as count_sum,
                sum(total_price-total_purchase_price)  as price_sum').joins(:agent).group(:agent_name, :type, :payment_method).where(:paid => false, :payment_method => 'poa', :type => "IndividualReservation", :status => "checkedin").reorder(:agent_id)
    (prepay_purchase_sum + poa_purchase_sum).sort_by(&:agent_name)
  end
end
