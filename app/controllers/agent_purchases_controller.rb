class AgentPurchasesController < ApplicationController
  before_filter :set_agent

  def index
    @spot_name = params[:spot_name]
    @date = params[:date]
    condition = {}
    if @spot_name.present?
      condition[:spot] = {:name.matches => "%#{@spot_name}%"}
    end
    if @date.present?
      condition[:date.lte] = @date
    end
    @table = @agent.reservations.joins(:spot).where(condition).sum_purchase_with_spots
  end

  def reservations
    @date = params[:date]
    @spot_name = params[:spot_name]
    @spot = Spot.find(params[:spot_id])
    @reservations = @agent.reservations.where(:spot_id => params[:spot_id], :payment_method => params[:payment_method], :type => params[:type], :settled => false, :status => "checkedin")
    if @date.present?
      @reservations = @reservations.where(:date.lte => @date)
    end
    @reservations
  end

  def update_settled
    ids = id_list(params[:reservation_ids])
    if ids.present?
      PurchaseHistory.transaction do
        reservations = @agent.reservations.where(:payment_method => "poa").find(ids)
        spot_id = reservations[0].spot_id
        price = reservations.sum(&:total_price)-reservations.sum(&:total_purchase_price)
        purchase_history = @agent.purchase_histories.create(:purchase_date => Date.today, :user => current_user.name, :spot_id => spot_id, :is_individual => true, :payment_method => "poa", :price => price)
        purchase_history.save
        @agent.reservations.where(:payment_method => "poa").update_all({:settled => true, :purchase_history_id => purchase_history}, :id => params[:reservation_ids])
      end
    end
    redirect_to agent_purchases_path({:date =>params[:date], :spot_name =>params[:spot_name]})
  end


  def report
    respond_to do |format|
      format.pdf do
        ids = id_list(params[:reservation_ids])
        if ids.present?
          @reservations = @agent.reservations.find(ids)
          @spot = Spot.find(@reservations[0].spot_id)
          @date = params[:date].empty? ? Date.today : params[:date]
          @purchase_price = @reservations.sum(&:total_purchase_price)
          @is_individual = @reservations[0].type == "IndividualReservation"
          @is_poa = @reservations[0].payment_method == "poa"
          @book_purchase_price = @reservations.sum(&:book_purchase_price)
          @adult_total_ticket_number = @reservations.sum(&:adult_ticket_number)
          @child_total_ticket_number = @reservations.sum(&:child_ticket_number)
          @adult_total_true_ticket_number = @reservations.sum(&:adult_true_ticket_number)
          @child_total_true_ticket_number = @reservations.sum(&:child_true_ticket_number)
          if @is_poa
            @price = @reservations.sum(&:total_price)
            @book_price = @reservations.sum(&:book_price)
            render "poa_report"
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
