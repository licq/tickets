#coding: utf-8
class AgentPricesController < ApplicationController

  before_filter :set_spot

  def index
    redirect_to seasons_path, :notice => "必须先设置淡旺季" if @spot.seasons.empty?
    redirect_to tickets_path, :notice => "必须先设置门票" if @spot.tickets.empty?

    @agent_prices = @spot.agent_prices
  end

  def new
    @agent_price = @spot.agent_prices.build
    @spot.seasons.each do |s|
      @spot.tickets.each do |t|
        @agent_price.team_rates << @agent_price.team_rates.build(:season => s, :ticket => t)
        @agent_price.individual_rates << @agent_price.individual_rates.build(:season => s, :ticket => t)
      end
    end
  end

  def create
    @agent_price = @spot.agent_prices.new(params[:agent_price])
    if @agent_price.save
      redirect_to agent_prices_path, :notice => "创建已成功."
    else
      render :action => 'new'
    end
  end

  def edit
    @agent_price = @spot.agent_prices.find(params[:id])
    @spot.seasons.each do |season|
      @spot.tickets.each do |ticket|
        unless @agent_price.team_rate_for(season.name, ticket.name)
          @agent_price.team_rates << @agent_price.team_rates.build(:season => season, :ticket => ticket)
        end
        unless @agent_price.individual_rate_for(season.name, ticket.name)
          @agent_price.individual_rates << @agent_price.individual_rates.build(:season => season, :ticket => ticket)
        end
      end
    end
  end

  def update
    @agent_price = @spot.agent_prices.find(params[:id])
    if @agent_price.update_attributes(params[:agent_price])
      redirect_to agent_prices_path, :notice => "修改已成功."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @agent_price = @spot.agent_prices.find(params[:id])
    @agent_price.destroy
    redirect_to agent_prices_url, :notice => "删除已成功."
  end
end
