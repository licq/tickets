class BookTicket < ActiveRecord::Base

  belongs_to :spot
  belongs_to :agent
  belongs_to :city
  belongs_to :ticket

  validates :linkman, :presence => true
  validates :linktel, :presence => true
  validates :spot_id, :presence => true
  validates :city_id, :presence => true

  def  count_individual_total_price
      total_price = self.adult_ticket_number * self.adult_sale_price + self.child_ticket_number * self.child_sale_price
      return total_price
  end

  def  count_team_total_price
      total_price = self.adult_ticket_number * self.adult_price + self.child_ticket_number * self.child_price
      return total_price
  end

end
