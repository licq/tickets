# == Schema Information
# Schema version: 20110405152243
#
# Table name: users
#
#  id            :integer         not null, primary key
#  username      :string(255)
#  email         :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  name          :string(255)
#  type          :string(255)
#  spot_id       :integer
#

class SpotOperator < User
  belongs_to :spot
  belongs_to :role
  has_many :menus, :through => :role
  has_many :menu_groups, :through => :menus

#  def menu_groups
#    result = Hash.new{|h,k| h[k] = []}
#    self.menus.each do |menu|
#       result[menu.menu_group.name] << menu
#    end
#    result
#  end

end
