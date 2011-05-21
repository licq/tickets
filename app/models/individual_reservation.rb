class IndividualReservation < Reservation
  def calculate_price
    if (child_sale_price.nil?)
      self.adult_ticket_number * self.adult_sale_price
    else
      self.adult_ticket_number * self.adult_sale_price + self.child_ticket_number * self.child_sale_price
    end
  end

  def calculate_purchase_price
    if (child_purchase_price.nil?)
      self.adult_ticket_number * self.adult_purchase_price
    else
      self.adult_ticket_number * self.adult_purchase_price + self.child_ticket_number * self.child_purchase_price
    end
  end

  def is_individual?
    true
  end
end