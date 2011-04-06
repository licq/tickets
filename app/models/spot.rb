#coding: utf-8
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

  scope :name_like, lambda{|q| where('name like ?', "%#{q}%")}
  scope :city_like, lambda{|cn| where()}
  scope :status, lambda{|b| where('disabled = ? ' , b)}

  def city_tokens=(ids)
    self.city_ids = ids.split(",")
  end

  def self.search(name,city_name,disabled_value)
    where_string = "spots.id=cities_spots.spot_id and cities.id=cities_spots.city_id "
    where_string += " and spots.name like :name" unless name.blank?
    where_string += " and cities.name like :city_name" unless city_name.blank?
    disabled_value = false if disabled_value.nil?
    where_string += " and spots.disabled = :disabled"
      
    select(:*).from("spots,cities,cities_spots").where(where_string,:name => "%#{name}%",:city_name => "%#{city_name}%",
                                                       :disabled => disabled_value)
  end
end
