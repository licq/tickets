#coding: utf-8
class Timespan < ActiveRecord::Base
  belongs_to :season
  validates :from, :presence => true
  validates :to, :presence => true
  validates :spot,:presence => true
  validate :from_before_to, :unique_within_spot
  belongs_to :spot

  def from_before_to
    if self.from && self.to && self.from > self.to
      self.errors.add(:to, "结束时间应大于起始时间")
    end
  end

  def unique_within_spot
    if self.season && self.season.spot
      spot = self.season.spot
      spot.timespans do |timespan|
        if self.overlap?(timespan)
          self.errors[:base] = "与其他时间段重合"
          break
        end
      end
    end
  end

  def overlap?(another)
    if (self.from && self.to(self.from <= another.to && self.from >= another.from) || (self.to <= another.to && self.to >= another.from))
      true
    else
      false
    end
  end
end
