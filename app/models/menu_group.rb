class MenuGroup < ActiveRecord::Base
  default_scope order('id')
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