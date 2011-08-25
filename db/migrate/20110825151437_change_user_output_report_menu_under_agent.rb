class ChangeUserOutputReportMenuUnderAgent < ActiveRecord::Migration
  def self.up
    menu = Menu.where(:url => "reports_agent_user_output_path").first
    menu_group = MenuGroup.where(:category => "agent", :seq => 6).first
    menu.menu_group = menu_group
    menu.save
  end

  def self.down
  end
end
