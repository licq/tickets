class Menu < ActiveRecord::Base

  default_scope order('menu_group_id,id')
  belongs_to :menu_group
  has_and_belongs_to_many :roles
end