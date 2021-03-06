class SpotPurchasesController < ApplicationController
  before_filter :set_spot

  def index
    @agent_name = params[:agent_name]
    @date = params[:date]
    condition = {}
    if @agent_name.present?
      condition[:agent] = {:name.matches => "%#{@agent_name}%"}
    end
    if @date.present?
      condition[:date.lte] = @date
    end
    @table = @spot.reservations.joins(:agent).where(condition).sum_purchase_with_agents
  end

  def reservations
    @date = params[:date]
    @agent_name = params[:agent_name]
    @agent = Agent.find(params[:agent_id])
    @reservations = @spot.reservations.where(:agent_id => params[:agent_id], :payment_method => params[:payment_method], :type => params[:type], :settled => false, :status => "checkedin")
    if @date.present?
      @reservations = @reservations.where(:date.lte => @date)
    end
    @reservations
  end

  def update_settled
    ids = id_list(params[:reservation_ids])
    if ids.present?
      PurchaseHistory.transaction do
        reservations = @spot.reservations.where(:payment_method => "prepay").find(ids)
        agent_id = reservations[0].agent_id
        is_individual = reservations[0].is_individual?
        price = reservations.sum(&:total_purchase_price)
        purchase_history = @spot.purchase_histories.create(:purchase_date => Date.today, :user => current_user.name, :agent_id => agent_id, :is_individual => is_individual, :payment_method => "prepay", :price => price)
        purchase_history.save!
        @spot.reservations.where(:payment_method => "prepay").update_all({:paid => true, :settled => true, :purchase_history_id => purchase_history}, :id => params[:reservation_ids])
      end
    end
    redirect_to spot_purchases_path({:date =>params[:date], :agent_name =>params[:agent_name]})
  end

  def report
    respond_to do |format|
      format.pdf do
        ids = id_list(params[:reservation_ids])
        if ids.present?
          @reservations = @spot.reservations.find(ids)
          @agent = Agent.find(@reservations[0].agent_id)
          @date = params[:date].empty? ? Date.today : params[:date]
          @purchase_price = @reservations.sum(&:total_purchase_price)
          @is_individual = @reservations[0].type == "IndividualReservation"
          @book_purchase_price = @reservations.sum(&:book_purchase_price)
          @adult_total_ticket_number = @reservations.sum(&:adult_ticket_number)
          @child_total_ticket_number = @reservations.sum(&:child_ticket_number)
          @adult_total_true_ticket_number = @reservations.sum(&:adult_true_ticket_number)
          @child_total_true_ticket_number = @reservations.sum(&:child_true_ticket_number)
          case @reservations[0].payment_method
            when "poa"
              @price = @reservations.sum(&:total_price)
              @book_price = @reservations.sum(&:book_price)
              render "poa_report"
            when "net"
              render "net_report"
            else
              render "report"
          end
        end
      end
    end
  end

  private
  def id_list(id_string)
    id_string.present? ? id_string.split(",") : nil
  end

end
