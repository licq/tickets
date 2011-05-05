class BookTicket < ActiveRecord::Base

  belongs_to :spot
  belongs_to :agent
  belongs_to :city
  belongs_to :ticket

  validates :linkman, :presence => true
  validates :linktel, :presence => true
  validates :spot_id, :presence => true
  validates :city_id, :presence => true
  attr_reader :spot_tokens

  def spot_tokens(ids)
    self.spot_ids = ids.split(",")
  end

  def self.count_individual_total_price(book_ticket)
    individual_rate = IndividualRate.select('individual_rates.*').
        joins("join rfps on individual_rates.agent_price_id = rfps.agent_price_id
               join timespans on individual_rates.season_id = timespans.season_id").
        where("rfps.spot_id  = ? and rfps.agent_id  = ?
              and individual_rates.ticket_id = ? and
              timespans.from_date <= ? and timespans.to_date >= ?",
              book_ticket.spot_id,book_ticket.agent_id,book_ticket.ticket_id,book_ticket.date,book_ticket.date)
    total_price = book_ticket.adult_ticket_number * individual_rate[0].adult_sale_price + book_ticket.child_ticket_number * individual_rate[0].child_sale_price
    return total_price
  end

  def self.count_team_total_price(book_ticket)
    team_rate = TeamRate.select('team_rates.*').
        joins("join rfps on team_rates.agent_price_id = rfps.agent_price_id
               join timespans on team_rates.season_id = timespans.season_id").
        where("rfps.spot_id  = ? and rfps.agent_id  = ?
              and team_rates.ticket_id = ? and
              timespans.from_date <= ? and timespans.to_date >= ?",
              book_ticket.spot_id,book_ticket.agent_id,book_ticket.ticket_id,book_ticket.date,book_ticket.date)
    total_price = book_ticket.adult_ticket_number * team_rate[0].adult_price + book_ticket.child_ticket_number * team_rate[0].child_price
    return total_price
  end

end
