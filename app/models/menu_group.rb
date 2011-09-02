class MenuGroup < ActiveRecord::Base
  default_scope order('seq')
  scope :for_spot, where(:category => 'spot')
  scope :for_agent, where(:category => 'agent')
  has_many :menus

  def add_menu(m)
    @my_menus ||= []
    @my_menus.push(m)
  end

  def my_menus
    @my_menus || menus
  end
end
# == Schema Information
#
# Table name: menu_groups
#
#  id       :integer(4)      not null, primary key
#  name     :string(255)
#  category :string(255)
#  seq      :integer(4)
#

