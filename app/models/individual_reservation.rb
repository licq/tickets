class IndividualReservation < Reservation
  def calculate_price
    result = self.adult_ticket_number * self.adult_sale_price
    if can_book_child_ticket?
      result += self.child_ticket_number * self.child_sale_price
    end
    result
  end

  def calculate_true_price
    result = self.adult_true_ticket_number * self.adult_sale_price
    if can_book_child_ticket?
      result += self.child_true_ticket_number * self.child_sale_price
    end
    result
  end

  def calculate_purchase_price
    result = self.adult_ticket_number * self.adult_purchase_price
    if can_book_child_ticket?
      result += self.child_ticket_number * self.child_purchase_price
    end
    result
  end

  def calculate_true_purchase_price
    result = self.adult_true_ticket_number * self.adult_purchase_price
    if can_book_child_ticket?
      result += self.child_true_ticket_number * self.child_purchase_price
    end
    result
  end

  def save_total_price
    self.total_price = calculate_price
    self.total_purchase_price = calculate_purchase_price
    self.save
  end

  def set_true_total_price
    self.total_price = calculate_true_price
    self.total_purchase_price = calculate_true_purchase_price
  end

  def is_individual?
    true
  end

  def can_book_child_ticket?
    if self.child_sale_price && self.child_purchase_price
      true
    else
      false
    end
  end

end