#coding: utf-8
class BookTicketsController < ApplicationController

  before_filter :set_agent

  def index
    @search = @agent.book_tickets.search(params[:search])
    page = params[:page].to_i
    @book_tickets= @search.page(page)
    if (@book_tickets.all.empty?) && (page > 1)
      @book_tickets = @search.page(page -1)
    end
  end



  def create
    @book_ticket = @agent.book_tickets.new(params[:book_ticket])
    if(@book_ticket.is_team?)
      @book_ticket.total_price = BookTicket.count_team_total_price(@book_ticket)
    else
      @book_ticket.total_price = BookTicket.count_individual_total_price(@book_ticket)
    end
    if @book_ticket.save
      redirect_to book_tickets_url, :notice => "已预订成功."
    else
      render :action => 'new'
    end
  end

  def edit
    @book_ticket = @agent.book_tickets.find(params[:id])
  end

  def update
    @book_ticket = @agent.book_tickets.find(params[:id])
    if @book_ticket.update_attributes(params[:book_ticket])
      redirect_to book_tickets_url, :notice  => "已修改成功."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @book_ticket = @agent.book_tickets.find(params[:id])
    @book_ticket.destroy
    redirect_to book_tickets_url, :notice => "已删除成功"
  end

  def individual
    @book_ticket = @agent.book_tickets.build(:is_team => false)
    render :action => 'new'
  end

  def team
    @book_ticket = @agent.book_tickets.build(:is_team => true)
    render :action => 'new'
  end

end
