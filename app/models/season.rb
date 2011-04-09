#coding: utf-8
class Season < ActiveRecord::Base
  validates :name, :presence => true,:uniqueness => {:scope => :spot_id}
  validates :spot, :presence => true
  validates :timespans , :presence => {:message => "至少添加一个时间段"}
  validates_associated :timespans

  belongs_to :spot
  has_many :timespans,:conditions => proc{"'#{Date.today.to_s(:db)}' BETWEEN from AND to"}
end
