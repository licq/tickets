class TeamReservation < Reservation
  def calculate_price
    self.adult_ticket_number * self.adult_price + self.child_ticket_number * self.child_price
  end
end