#encoding: utf-8
class ManualsController < ApplicationController
  def spot
    send_file File.join(Rails.public_path , "景区-旅行社业务合作平台操作手册(景区).pdf"),:type => 'application/pdf', :disposition => 'attachment'
  end

  def agent
    send_file File.join(Rails.public_path ,"景区-旅行社业务合作平台操作手册(旅行社).pdf"),:type => 'application/pdf', :disposition => 'attachment'
  end

end
