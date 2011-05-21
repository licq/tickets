class TeamReservation < Reservation
  def calculate_price
    if (self.child_price.nil?)
      self.adult_ticket_number * self.adult_price
    else
      self.adult_ticket_number * self.adult_price + self.child_ticket_number * self.child_price
    end
  end

  def is_individual?
    false
  end
end