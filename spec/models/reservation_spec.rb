require File.dirname(__FILE__) + '/../spec_helper'

describe Reservation do
  before(:each) do
    Ticket.delete_all
    User.delete_all
    City.delete_all
    Spot.delete_all
    Season.delete_all
    Agent.delete_all
    AgentPrice.delete_all
    Rfp.delete_all
    IndividualRate.delete_all
  end

  it "should be valid" do
    Factory.build(:reservation).should be_valid
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

