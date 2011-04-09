#coding: utf-8
class Timespan < ActiveRecord::Base
  belongs_to :season
  validates :from, :presence => true
  validates :to, :presence => true
  validate :from_before_to

  def from_before_to
    if self.from && self.to && self.from > self.to
      self.errors.add(:to, "结束时间应大于起始时间")
    end
  end

  def overlap(another)
    if ((self.from <= another.to && self.from >= another.from) || (self.to <= another.to && self.to >= another.from))
      true
    else
      false
    end
  end
end
