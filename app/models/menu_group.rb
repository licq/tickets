class MenuGroup < ActiveRecord::Base
  default_scope order('id')
  scope :for_spot, where(:category => 'spot')
  has_many :menus
end