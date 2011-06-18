class TeamReservation < Reservation
  def calculate_price
    result = self.adult_ticket_number * self.adult_price
    if can_book_child_ticket?
      result += self.child_ticket_number * self.child_price
    end
    result
  end

  def calculate_true_price
    result = self.adult_true_ticket_number * self.adult_price
    if can_book_child_ticket?
      result += self.child_true_ticket_number * self.child_price
    end
    result
  end

  def is_individual?
    false
  end

  def save_total_price
    self.book_price = calculate_price
    self.total_price = self.book_price
    self.save
  end

  def set_true_total_price
    self.total_price = calculate_true_price
  end

  def can_book_child_ticket?
    return false if self.child_price.nil?
    true
  end

end