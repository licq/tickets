#coding: utf-8
module ApplicationHelper
  def show_disabled(disabled)
    disabled ? "已禁用" : "正常"
  end
end
