class TeamReservation < Reservation
  before_save :set_total_purchase_price
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

  private
  def set_total_purchase_price
    self.book_purchase_price = self.book_price
    self.total_purchase_price = self.total_price
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

