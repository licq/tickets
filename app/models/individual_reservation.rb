class IndividualReservation < Reservation
  def calculate_price
    self.adult_ticket_number * self.adult_sale_price + self.child_ticket_number * self.child_sale_price
  end

  def calculate_purchase_price
    self.adult_ticket_number * self.adult_purchase_price + self.child_ticket_number * self.child_purchase_price
  end
end