require File.dirname(__FILE__) + '/../spec_helper'

describe Message do
  it "should be valid" do
    Message.new.should be_valid
  end
end

# == Schema Information
#
# Table name: messages
#
#  id                :integer(4)      not null, primary key
#  message_from_id   :integer(4)
#  message_from_type :string(255)
#  message_to_id     :integer(4)
#  message_to_type   :string(255)
#  content           :string(255)
#  read              :boolean(1)      default(FALSE)
#  created_at        :datetime
#  updated_at        :datetime
#

