class Menu < ActiveRecord::Base

  default_scope order('menu_group_id,id')
  belongs_to :menu_group
end