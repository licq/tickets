#coding: utf-8
class AddVerifyToMenus < ActiveRecord::Migration
  def self.up
    Reservation.update_all(:verified => true)
    menu = Menu.where(:url => "unverified_reservations_path")
    if menu.blank?
      Menu.create!(:name => "待审核订单", :url => "unverified_reservations_path",
                   :menu_group => MenuGroup.where(:category => "agent", :seq => 4).first)
    end
  end

  def self.down
  end
end
