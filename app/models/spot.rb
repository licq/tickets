class Spot < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :code, :presence => true, :uniqueness => true
  validates_associated :admin
  validates_presence_of :admin, :on => :create

  has_many :users
  has_one :admin,:class_name => 'SpotAdmin'
  has_one :operators,:class_name => 'SpotOperator'

  accepts_nested_attributes_for :admin
end
