#coding: utf-8
class Timespan < ActiveRecord::Base
  default_scope where("to_date >= ?",Date.today).order(:from_date)
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
    if ((self.from_date <= another.to_date && self.from_date >= another.from_date) ||
        (self.to_date <= another.to_date && self.to_date >= another.from_date) ||
        (self.from_date <= another.from_date && self.to_date >= another.to_date) )
      true
    else
      false
    end
  end

  def self.has_overlap(timespans)
    0.upto(timespans.size - 2) do |i|
      (i + 1).upto(timespans.size - 1) do |j|
        if timespans[i].overlap(timespans[j])
          return [timespans[i], timespans[j]]
        end
      end
    end
    nil
  end

  def to_s
    "#{from_date}--#{to_date}"
  end
end
