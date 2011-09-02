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
    self.book_price = calculate_price
    self.book_purchase_price = calculate_purchase_price
    self.total_price = self.book_price
    self.total_purchase_price = self.book_purchase_price
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
# == Schema Information
#
# Table name: reservations
#
#  id                       :integer(4)      not null, primary key
#  no                       :string(255)
#  agent_id                 :integer(4)
#  spot_id                  :integer(4)
#  ticket_name              :string(255)
#  child_sale_price         :integer(4)
#  child_purchase_price     :integer(4)
#  adult_sale_price         :integer(4)
#  adult_purchase_price     :integer(4)
#  adult_price              :integer(4)
#  child_price              :integer(4)
#  child_ticket_number      :integer(4)      default(0)
#  adult_ticket_number      :integer(4)      default(1)
#  date                     :date
#  type                     :string(255)
#  status                   :string(255)
#  contact                  :string(255)
#  phone                    :string(255)
#  total_price              :integer(4)
#  total_purchase_price     :integer(4)
#  paid                     :boolean(1)
#  adult_true_ticket_number :integer(4)
#  child_true_ticket_number :integer(4)
#  created_at               :datetime
#  updated_at               :datetime
#  payment_method           :string(255)
#  book_price               :integer(4)
#  book_purchase_price      :integer(4)
#  group_no                 :string(255)
#  purchase_history_id      :integer(4)
#  note                     :text
#  user_id                  :integer(4)
#  verified                 :boolean(1)      default(FALSE)
#  settled                  :boolean(1)
#  pay_id                   :string(255)
#  pay_time                 :datetime
#

