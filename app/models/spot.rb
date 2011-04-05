class Spot < ActiveRecord::Base
  attr_accessible :name, :code, :description

  validates :name, :presence => true, :uniqueness => true
  validates :code, :presence => true, :uniqueness => true

  has_many :users
  has_one :administrator,  :class_name => 'SpotAdmin', :conditions => {:type => "SpotAdmin"}

  def administrator_attibures=(attributes)
    logger.error(attributes)
    self.users << SpotAdmin.new(attributes)
  end
end
