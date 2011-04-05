User.delete_all
SystemAdmin.create!(:name => "Admin", :username => "admin", :password => "foobar",
                    :password_confirmation => "foobar", :email => "aa@aa.com")
