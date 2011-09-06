class Menu < ActiveRecord::Base

  default_scope order('menu_group_id,seq')
  belongs_to :menu_group
  has_and_belongs_to_many :roles
end
# == Schema Information
#
# Table name: menus
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  url           :string(255)
#  menu_group_id :integer(4)
#  seq           :integer(4)
#

