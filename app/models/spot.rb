class Spot < ActiveRecord::Base
  attr_accessible :name, :code, :description

  validates :name, :presence => true, :uniqueness => true
  validates :code, :presence => true, :uniqueness => true
  validates_associated :administrator, :on => :create

  has_many :users
  has_one :administrator,  :class_name => 'SpotAdmin', :conditions => {:type => "SpotAdmin"}
  accepts_nested_attributes_for :administrator

end
