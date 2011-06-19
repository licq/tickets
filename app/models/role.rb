class Role < ActiveRecord::Base
  belongs_to :roleable, :polymorphic => true
  has_and_belongs_to_many :menus

  validates_presence_of :name
  validates_presence_of :menus

  has_many :users

  def can_edit?
    users.empty?
  end
end