#coding: utf-8
class AgentPricesController < ApplicationController

  before_filter :set_spot

  def index
    redirect_to seasons_path, :notice => "必须先设置淡旺季" if @spot.seasons.empty?
    redirect_to tickets_path, :notice => "必须先设置门票" if @spot.tickets.empty?

    @agent_prices = @spot.agent_prices
  end

  def show
    @agent_price = AgentPrice.find(params[:id])
  end

  def new
    @agent_price = AgentPrice.new
  end

  def create
    @agent_price = AgentPrice.new(params[:agent_price])
    if @agent_price.save
      redirect_to @agent_price, :notice => "Successfully created agent price."
    else
      render :action => 'new'
    end
  end

  def edit
    @agent_price = AgentPrice.find(params[:id])
  end

  def update
    @agent_price = AgentPrice.find(params[:id])
    if @agent_price.update_attributes(params[:agent_price])
      redirect_to @agent_price, :notice  => "Successfully updated agent price."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @agent_price = AgentPrice.find(params[:id])
    @agent_price.destroy
    redirect_to agent_prices_url, :notice => "Successfully destroyed agent price."
  end
end
