#coding: utf-8
class Season < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => {:scope => :spot_id}
  validates_length_of :timespans, :minimum => 1, :message => "至少添加一个时间段"

  belongs_to :spot
  has_many :timespans, :dependent => :delete_all
  has_many :public_rates, :dependent => :delete_all
  has_many :team_rates, :dependent => :delete_all
  has_many :individual_rates, :dependent => :delete_all
  accepts_nested_attributes_for :timespans,
                                :reject_if => lambda { |a| a[:from_date].blank? || a[:to_date].blank? },
                                :allow_destroy => true
end

# == Schema Information
#
# Table name: seasons
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  spot_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

