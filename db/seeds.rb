#coding: utf-8
#User.delete_all
#SystemAdmin.create!(:name => "Admin", :username => "admin", :password => "foobar",
#                    :password_confirmation => "foobar", :email => "aa@aa.com")
#City.delete_all
#City.create!(:name => "北京", :code => "001", :pinyin => "beijing")
#City.create!(:name => "上海", :code => "002", :pinyin => "shanghai")
#City.create!(:name => "泰山", :code => "003", :pinyin => "taishan")
#City.create!(:name => "南京", :code => "004", :pinyin => "nanjing")

MenuGroup.delete_all
spot_menu_group1 = MenuGroup.create!(:name => "基础设置", :category => "spot", :seq => 1)
spot_menu_group2 = MenuGroup.create!(:name => "用户管理", :category => "spot", :seq => 2)
spot_menu_group3 = MenuGroup.create!(:name => "角色管理", :category => "spot", :seq => 3)
spot_menu_group4 = MenuGroup.create!(:name => "旅行社列表", :category => "spot", :seq => 4)
spot_menu_group5 = MenuGroup.create!(:name => "订单管理", :category => "spot", :seq => 5)
spot_menu_group6 = MenuGroup.create!(:name => "报表", :category => "spot", :seq => 6)
spot_menu_group7 = MenuGroup.create!(:name => "结算管理", :category => "spot", :seq => 7)

system_menu_group1 = MenuGroup.create!(:name => "景区管理", :category => "system", :seq => 1)
system_menu_group2 = MenuGroup.create!(:name => "旅行社管理", :category => "system", :seq => 2)
system_menu_group3 = MenuGroup.create!(:name => "合作管理", :category => "system", :seq => 3)
system_menu_group4 = MenuGroup.create!(:name => "订单管理", :category => "system", :seq => 4)
system_menu_group5 = MenuGroup.create!(:name => "结算管理", :category => "system", :seq => 5)

agent_menu_group1 = MenuGroup.create!(:name => "用户管理", :category => "agent", :seq => 1)
agent_menu_group2 = MenuGroup.create!(:name => "角色管理", :category => "agent", :seq => 2)
agent_menu_group3 = MenuGroup.create!(:name => "景区列表", :category => "agent", :seq => 3)
agent_menu_group4 = MenuGroup.create!(:name => "订单管理", :category => "agent", :seq => 4)
agent_menu_group5 = MenuGroup.create!(:name => "结算管理", :category => "agent", :seq => 5)
agent_menu_group6 = MenuGroup.create!(:name => "报表", :category => "agent", :seq => 6)


Menu.delete_all
Menu.create!(:name => "淡旺季设置", :url => "seasons_path", :menu_group => spot_menu_group1, :seq => 1)
Menu.create!(:name => "门票设置", :url => "tickets_path", :menu_group => spot_menu_group1, :seq => 2)
Menu.create!(:name => "旅行社价格", :url => "agent_prices_path", :menu_group => spot_menu_group1, :seq => 3)

Menu.create!(:name => "新建用户", :url => "new_user_path", :menu_group => spot_menu_group2, :seq => 1)
Menu.create!(:name => "用户列表", :url => "users_path", :menu_group => spot_menu_group2, :seq => 2)

Menu.create!(:name => "新建角色", :url => "new_role_path", :menu_group => spot_menu_group3, :seq => 1)
Menu.create!(:name => "角色列表", :url => "roles_path", :menu_group => spot_menu_group3, :seq => 2)

Menu.create!(:name => "已开通预订旅行社", :url => "rfps_path", :menu_group => spot_menu_group4, :seq => 1)
Menu.create!(:name => "已申请待开通旅行社", :url => "applied_spot_agents_path", :menu_group => spot_menu_group4, :seq => 2)
Menu.create!(:name => "未开通预订旅行社", :url => "spot_agents_path", :menu_group => spot_menu_group4, :seq => 3)

Menu.create!(:name => "订单列表", :url => "spot_reservations_path", :menu_group => spot_menu_group5, :seq => 1)
Menu.create!(:name => "当日订单", :url => "today_spot_reservations_path", :menu_group => spot_menu_group5, :seq => 2)

Menu.create!(:name => "产量统计报表", :url => "reports_spot_output_path", :menu_group => spot_menu_group6, :seq => 1)
Menu.create!(:name => "产量同比环比报表", :url => "reports_spot_output_rate_path", :menu_group => spot_menu_group6, :seq => 2)
Menu.create!(:name => "入园统计报表", :url => "reports_spot_checkin_path", :menu_group => spot_menu_group6, :seq => 3)
Menu.create!(:name => "分销商销售业绩报表", :url => "reports_spot_agent_output_path", :menu_group => spot_menu_group6, :seq => 4)

Menu.create!(:name => "结算列表", :url => "spot_purchases_path", :menu_group => spot_menu_group7, :seq => 1)
Menu.create!(:name => "结算历史", :url => "purchase_histories_path", :menu_group => spot_menu_group7, :seq => 2)

Menu.create!(:name => "新建景区", :url => "new_spot_path", :menu_group => system_menu_group1, :seq => 1)
Menu.create!(:name => "景区查询", :url => "spots_path", :menu_group => system_menu_group1, :seq => 2)

Menu.create!(:name => "新建旅行社", :url => "new_agent_path", :menu_group => system_menu_group2, :seq => 1)
Menu.create!(:name => "旅行社查询", :url => "agents_path", :menu_group => system_menu_group2, :seq => 2)

Menu.create!(:name => "合作列表", :url => "all_rfps_path", :menu_group => system_menu_group3, :seq => 1)

Menu.create!(:name => "订单列表", :url => "all_reservations_path", :menu_group => system_menu_group4, :seq => 1)

Menu.create!(:name => "结算列表", :url => "all_purchases_path", :menu_group => system_menu_group5, :seq => 1)
Menu.create!(:name => "结算历史", :url => "all_purchase_histories_path", :menu_group => system_menu_group5, :seq => 2)

Menu.create!(:name => "新建用户", :url => "new_agent_user_path", :menu_group => agent_menu_group1, :seq => 1)
Menu.create!(:name => "用户列表", :url => "agent_users_path", :menu_group => agent_menu_group1, :seq => 2)

Menu.create!(:name => "新建角色", :url => "new_agent_role_path", :menu_group => agent_menu_group2, :seq => 1)
Menu.create!(:name => "角色列表", :url => "agent_roles_path", :menu_group => agent_menu_group2, :seq => 2)

Menu.create!(:name => "可预订景区", :url => "agent_rfps_path", :menu_group => agent_menu_group3, :seq => 1)
Menu.create!(:name => "已申请预订景区", :url => "applied_agent_spots_path", :menu_group => agent_menu_group3, :seq => 2)
Menu.create!(:name => "未开通预订景区", :url => "agent_spots_path", :menu_group => agent_menu_group3, :seq => 3)

Menu.create!(:name => "新建订单", :url => "new_reservation_path", :menu_group => agent_menu_group4, :seq => 1)
Menu.create!(:name => "订单列表", :url => "reservations_path", :menu_group => agent_menu_group4, :seq => 2)

Menu.create!(:name => "结算列表", :url => "agent_purchases_path", :menu_group => agent_menu_group5, :seq => 1)
Menu.create!(:name => "结算历史", :url => "agent_purchase_histories_path", :menu_group => agent_menu_group5, :seq => 2)

Menu.create!(:name => "产量统计报表", :url => "reports_agent_output_path", :menu_group => agent_menu_group6, :seq => 1)
Menu.create!(:name => "产量同比环比报表", :url => "reports_agent_output_rate_path", :menu_group => agent_menu_group6, :seq => 2)
Menu.create!(:name => "入园统计报表", :url => "reports_agent_checkin_path", :menu_group => agent_menu_group6, :seq => 3)
Menu.create!(:name => "景区销售业绩报表", :url => "reports_agent_spot_output_path", :menu_group => agent_menu_group6, :seq => 4)
