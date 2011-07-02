class Message < ActiveRecord::Base
  belongs_to :message_from, :polymorphic => true
  belongs_to :message_to, :polymorphic => true

  scope :unread, where(:read => false)
  default_scope order("created_at desc")

end
