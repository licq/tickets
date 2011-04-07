#coding: utf-8
# == Schema Information
# Schema version: 20110405152243
#
# Table name: spots
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  code        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  disabled    :boolean         not null
#


class Spot < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :code, :presence => true, :uniqueness => true
  validates_associated :admin
  validates_presence_of :admin, :on => :create, :message => "必须设置管理员"
  validates :cities, :presence => {:message => "至少选择一个城市"}

  has_many :users
  has_one :admin,:class_name => 'SpotAdmin',:dependent => :delete
  has_one :operators,:class_name => 'SpotOperator'
  has_and_belongs_to_many :cities
  attr_reader :city_tokens

  accepts_nested_attributes_for :admin

  def city_tokens=(ids)
    self.city_ids = ids.split(",")
  end
end
