#coding: utf-8
Factory.sequence :city_code do |n|
  "#{n}"
end

Factory.define :city do |c|
  c.code { Factory.next(:city_code) }
  c.name {|city| "name#{city.code}"}
  c.pinyin {|city| "pinyin#{city.code}"}
end

Factory.sequence :username do |n|
  "username#{n}"
end
Factory.define :user do |u|
  u.username { Factory.next(:username) }
  u.name "name"
  u.email { |ur| "#{ur.username}@example.com" }
  u.password "foobar"
  u.password_confirmation { |ur| ur.password }
end

Factory.define :spot_admin do |u|
  u.username { Factory.next(:username) }
  u.name "name"
  u.email { |ur| "#{ur.username}@example.com" }
  u.password "foobar"
  u.password_confirmation { |ur| ur.password }
end

Factory.sequence :spot_code do |n|
  "#{n}"
end

Factory.define :spot do |s|
  s.code { Factory.next(:spot_code) }
  s.name { |ur| "spot#{ur.code}" }
  s.description "description"
  s.association :admin, :factory => :spot_admin
  s.cities { |cities| [cities.association(:city)] }
end

Factory.define :agent_operator do |u|
  u.username { Factory.next(:username) }
  u.name "name"
  u.email { |ur| "#{ur.username}@example.com" }
  u.password "foobar"
  u.password_confirmation { |ur| ur.password }
end

Factory.define :agent do |a|
  a.name "agent_name"
  a.description "agent description"
  a.association :operator, :factory => :agent_operator
end

Factory.sequence :season_name do |n|
   "season#{n}"
end

Factory.define :timespan do |t|
  t.from_date Date.today
  t.to_date {Date.today + 30}
end

Factory.define :season do |s|
  s.name {Factory.next(:season_name)}
  s.association :spot
  s.timespans {|ts| [ts.association(:timespan)]}
end

Factory.define :ticket do |t|
  t.name "ticketname"
end

Factory.sequence :agentpricename do |n|
  "agentpricename#{n}"
end

Factory.define :agent_price do |t|
  t.name { Factory.next(:agentpricename) }
end

Factory.define :rfp do |r|
  r.association :agent
  r.association :agent_price
  r.association :spot
end


Factory.define :reservation do |b|
  b.association :agent
  b.association :spot
  b.association :city
  b.association :ticket
  b.child_ticket_number 1
  b.adult_ticket_number 1
  b.date  Date.today+1
  b.linkman "lic"
  b.linktel "1234243"
  b.is_team false
  b.child_sale_price 100
  b.adult_sale_price 200
end

Factory.define :individual_rate do |i|

end

