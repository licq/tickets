class SpotAdmin < User
  attr_accessible :name, :username, :password, :password_confirmation, :email
  belongs_to :spot
end
