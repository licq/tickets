#coding: utf-8
class BookTicketsController < ApplicationController

  before_filter :set_agent

  def index
    params[:date] = Date.today + 1
  end

  def search
    @date = params[:date]
    @search = AgentPrice.connected_for_agent(@agent.id).search(:spot_name_contains => params[:spot_name],
                                                               :spot_cities_name_contains => params[:city_name])
    page = params[:page].to_i
    @agent_prices= @search.page(page)
    render :action => 'index'
  end


  def create
    @book_ticket = @agent.book_tickets.new(params[:book_ticket])
    if (@book_ticket.is_team?)
      @book_ticket.total_price = @book_ticket.count_team_total_price
    else
      @book_ticket.total_price = @book_ticket.count_individual_total_price
    end
    if @book_ticket.save
      redirect_to book_tickets_url, :notice => "已预订成功."
    else
      render :action => 'new'
    end
  end

#  def edit
#    @book_ticket = @agent.book_tickets.find(params[:id])
#  end
#
#  def update
#    @book_ticket = @agent.book_tickets.find(params[:id])
#    if @book_ticket.update_attributes(params[:book_ticket])
#      redirect_to book_tickets_url, :notice => "已修改成功."
#    else
#      render :action => 'edit'
#    end
#  end
#
#  def destroy
#    @book_ticket = @agent.book_tickets.find(params[:id])
#    @book_ticket.destroy
#    redirect_to book_tickets_url, :notice => "已删除成功"
#  end

  def individual
    @book_ticket = @agent.book_tickets.build(:is_team => false)
    @agent_price = AgentPrice.find(params[:agent_price])
    ticket = Ticket.find(params[:ticket])
    @book_ticket.spot = @agent_price.spot
    @book_ticket.ticket = ticket
    @book_ticket.date = params[:date]
    price = @agent_price.price_for(params[:date])
    if (price[ticket.id].nil? || price[ticket.id][:individual_rate].nil?)
      redirect_to book_tickets_url, :method => :post, :notice => "未设置价格，不能预订."
    else
      individual_rate =price[ticket.id][:individual_rate]
      @book_ticket.child_sale_price = individual_rate.child_sale_price
      @book_ticket.child_purchase_price = individual_rate.child_purchase_price
      @book_ticket.adult_sale_price = individual_rate.adult_sale_price
      @book_ticket.adult_purchase_price = individual_rate.adult_purchase_price
      render :action => 'new'
    end
  end

  def team
    @book_ticket = @agent.book_tickets.build(:is_team => true)
    @agent_price = AgentPrice.find(params[:agent_price])
    ticket = Ticket.find(params[:ticket])
    @book_ticket.spot = @agent_price.spot
    @book_ticket.ticket = ticket
    @book_ticket.date = params[:date]
    price = @agent_price.price_for(params[:date])
    if (price[ticket.id].nil? || price[ticket.id][:team_rate].nil?)
      redirect_to book_tickets_url, :method => :post, :notice => "未设置价格，不能预订."
    else
      team_rate =price[ticket.id][:team_rate]
      @book_ticket.child_price = team_rate.child_price
      @book_ticket.adult_price = team_rate.adult_price
      render :action => 'new'
    end
  end

end
