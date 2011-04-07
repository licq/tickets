#coding:utf-8
# == Schema Information
# Schema version: 20110405152243
#
# Table name: users
#
#  id            :integer         not null, primary key
#  username      :string(255)
#  email         :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  name          :string(255)
#  type          :string(255)
#  spot_id       :integer
#


class User < ActiveRecord::Base
  attr_accessor :password
  before_save :prepare_password

  validates_presence_of :username
  validates_uniqueness_of :username, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "只能包含数字，字母或下划线"
  validates_presence_of :name
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, :allow_blank => true
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true

  def self.authenticate(login, pass)
    user = find_by_username(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end
end
