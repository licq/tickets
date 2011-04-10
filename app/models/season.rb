#coding: utf-8
class Season < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => {:scope => :spot_id}
  validates_length_of :timespans, :minimum => 1, :message => "至少添加一个时间段"
#  validates_associated :timespans

  belongs_to :spot
  has_many :timespans, :dependent => :destroy
  accepts_nested_attributes_for :timespans, :reject_if => lambda { |a| a[:from_date].blank? || a[:to_date].blank? },
                                :allow_destroy => true
end
