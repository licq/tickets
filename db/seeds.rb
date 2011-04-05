#coding: utf-8
User.delete_all
SystemAdmin.create!(:name => "Admin", :username => "admin", :password => "foobar",
                    :password_confirmation => "foobar", :email => "aa@aa.com")

City.create!(:name => "北京", :code => "001", :pinyin => "beijing")
City.create!(:name => "上海", :code => "002", :pinyin => "shanghai")
City.create!(:name => "泰山", :code => "003", :pinyin => "taishan")
City.create!(:name => "南京", :code => "004", :pinyin => "nanjing")
