require 'spec_helper'

describe PurchaseHistory do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: purchase_histories
#
#  id             :integer(4)      not null, primary key
#  purchase_date  :date
#  user           :string(255)
#  agent_id       :integer(4)
#  spot_id        :integer(4)
#  price          :integer(4)
#  is_individual  :boolean(1)
#  payment_method :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

