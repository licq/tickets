#coding=utf-8
class TicketsController < ApplicationController

  before_filter :set_spot

  def index
    redirect_to seasons_path, :notice => "必须先设置淡旺季" if @spot.seasons.empty?
    @tickets = @spot.tickets
  end

  def new
    @ticket = @spot.tickets.build
    @ticket.public_rates = @spot.seasons.map { |season| @ticket.public_rates.new(:season => season) }
  end

  def create
    @ticket = @spot.tickets.build(params[:ticket])
    if @ticket.save
      redirect_to tickets_path, :notice => "创建已成功."
    else
      render :action => 'new'
    end
  end

  def edit
    @ticket = @spot.tickets.find(params[:id])
    @spot.seasons.each do |season|
      unless @ticket.public_rate_for(season.name)
        @ticket.public_rates << @ticket.public_rates.build(:season => season)
      end
    end
  end

  def update
    @ticket = @spot.tickets.find(params[:id])
    if @ticket.update_attributes(params[:ticket])
      redirect_to tickets_path, :notice => "修改已成功."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @ticket = @spot.tickets.find(params[:id])
    @ticket.destroy
    redirect_to tickets_url, :notice => "删除已成功."
  end
end
