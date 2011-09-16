class AgentPurchaseHistoriesController < ApplicationController
  before_filter :set_agent

  def index
    condition = params[:search]
    if condition.nil?
      condition = {}
    end
    @search = @agent.purchase_histories.search(prepare_ticket_type_condition(condition))
    page = params[:page].to_i
    @purchase_histories= @search.page(page)
  end

  def show
    @purchase_history = @agent.purchase_histories.find(params[:id])
  end


  def prepare_ticket_type_condition(condition)
     if current_user.is_spot_price_all != true
      if current_user.has_spot_team_price
        condition[:is_individual_eq] = false
      end

      if current_user.has_spot_individual_price
        condition[:is_individual_eq] = true
      end
     end
    condition
  end

end
