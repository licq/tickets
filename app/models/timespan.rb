#coding: utf-8
class Timespan < ActiveRecord::Base
#  scope :valid_timespans,lambda{ where(:from_date <= Date.today, :to_date >= Date.today)}
  default_scope where(":to_date >= ?",Date.today)
  belongs_to :season
  validates :from_date, :presence => true
  validates :to_date, :presence => true
  validate :from_before_to

  def from_before_to
    if self.from_date && self.to_date && self.from_date > self.to_date
      self.errors.add(:to_date, "结束时间应大于起始时间")
    end
  end

  def overlap(another)
    if ((self.from_date <= another.to_date && self.from_date >= another.from_date) || (self.to_date <= another.to_date && self.to_date >= another.from_date))
      true
    else
      false
    end
  end
end
