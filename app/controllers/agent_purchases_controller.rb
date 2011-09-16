class AgentPurchasesController < ApplicationController
  before_filter :set_agent

  def index
    @table = @agent.reservations.joins(:spot).where(prepare_index_condition).sum_purchase_with_spots
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
        reservations = @agent.reservations.find(ids)
        spot_id = reservations[0].spot_id
        is_individual = reservations[0].is_individual?
        payment_method = reservations[0].payment_method
        if payment_method == "poa"
          price = reservations.sum(&:total_price)-reservations.sum(&:total_purchase_price)
        elsif payment_method == "net"
          price = reservations.sum(&:book_purchase_price) - reservations.sum(&:total_purchase_price)
        end
        purchase_history = @agent.purchase_histories.create(:purchase_date => Date.today, :user => current_user.name, :spot_id => spot_id, :is_individual => is_individual, :payment_method => payment_method, :price => price)
        purchase_history.save
        @agent.reservations.where(:payment_method => payment_method).update_all({:settled => true, :purchase_history_id => purchase_history}, :id => params[:reservation_ids])
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
  def prepare_index_condition
    @spot_name = params[:spot_name]
    @date = params[:date]
    condition = {}
    if @spot_name.present?
      condition[:spot] = {:name.matches => "%#{@spot_name}%"}
    end
    if @date.present?
      condition[:date.lte] = @date
    end
    prepare_reservation_type_condition(condition)
  end

  def prepare_reservation_type_condition(condition)
     if current_user.is_spot_price_all != true
      if current_user.has_spot_team_price
        condition[:type.eq] = "TeamReservation"
      end

      if current_user.has_spot_individual_price
        condition[:type.eq] = "IndividualReservation"
      end
     end
    condition
  end

end
