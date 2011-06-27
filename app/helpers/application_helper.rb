#coding: utf-8
module ApplicationHelper
  def show_disabled(disabled)
    disabled ? "已禁用" : "正常"
  end

  def link_to_remove(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_field(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.simple_fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :tf => builder)
    end
    link_to_function(name, ("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

  def show_public_rate(public_rate)
    if public_rate
      "成人价格:#{public_rate.adult_price}<br/>儿童价格:#{public_rate.child_price}"
    end
  end

  def show_individual_adult_price(price_for_agent, ticket_id)
    price_for_agent[ticket_id] && price_for_agent[ticket_id][:individual_rate] &&
        price_for_agent[ticket_id][:individual_rate].adult_sale_price &&
        price_for_agent[ticket_id][:individual_rate].adult_purchase_price &&
        "#{price_for_agent[ticket_id][:individual_rate].adult_sale_price}/(" +
            "#{price_for_agent[ticket_id][:individual_rate].adult_purchase_price})" || "--"
  end

  def show_individual_child_price(price_for_agent, ticket_id)
    price_for_agent[ticket_id] && price_for_agent[ticket_id][:individual_rate] &&
        price_for_agent[ticket_id][:individual_rate].child_sale_price &&
        "#{price_for_agent[ticket_id][:individual_rate].child_sale_price}/(" +
            "#{price_for_agent[ticket_id][:individual_rate].child_purchase_price})" || "--"
  end

  def show_team_adult_price(price_for_agent, ticket_id)
    price_for_agent[ticket_id] && price_for_agent[ticket_id][:team_rate] &&
        price_for_agent[ticket_id][:team_rate].adult_price &&
        "#{price_for_agent[ticket_id][:team_rate].adult_price}" || "--"
  end

  def show_team_child_price(price_for_agent, ticket_id)
    price_for_agent[ticket_id] && price_for_agent[ticket_id][:team_rate] &&
        price_for_agent[ticket_id][:team_rate].child_price &&
        "#{price_for_agent[ticket_id][:team_rate].child_price}" || "--"
  end

  def show_reservation_type(reservation)
    if (reservation.is_individual?)
      "散客票"
    else
      "团队票"
    end
  end

  def show_reservation_type_with(type)
    if (type == 'IndividualReservation')
      "散客票"
    else
      "团队票"
    end
  end

  def show_reservation_adult_price(reservation)
    if (reservation.is_individual?)
      "#{reservation.adult_sale_price}/(#{reservation.adult_purchase_price})"
    else
      "#{reservation.adult_price}"
    end
  end

  def show_reservation_child_price(reservation)
    if (reservation.is_individual?)
      reservation.child_sale_price &&
          "#{reservation.child_sale_price}/(#{reservation.child_purchase_price})"|| "--"
    else
      reservation.child_price &&
          "#{reservation.child_price}"|| "--"
    end
  end

  def show_reservation_total_price(reservation)
    if (reservation.is_individual?)
      "#{reservation.total_price}/(#{reservation.total_purchase_price})"
    else
      "#{reservation.total_price}"
    end
  end

  def show_reservation_book_total_price(reservation)
    if (reservation.is_individual?)
      "#{reservation.book_price}/(#{reservation.book_purchase_price})"
    else
      "#{reservation.book_price}"
    end
  end

  def date_format(date)
    date.strftime("%Y-%m-%d")
  end

  def show_payment_method(payment_method)
    case payment_method
      when "poa" then
        "门口现付"
      when "prepay" then
        "挂账"
      else
        "--"
    end
  end

  def show_reservation_payment_method(reservation)
    case reservation.payment_method
      when "poa" then
        "门口现付"
      when "prepay" then
        "挂账"
      else
        "--"
    end
  end


  def show_rfp_status(status)
    case status
      when 'a' then
        '已申请'
      when 'r' then
        '已拒绝'
      when 'c' then
        '已合作'
    end
  end

  def show_rfp_agent_price_name(rfp)
    rfp.agent_price && "#{rfp.agent_price.name}" ||"--"
  end

  def show_rfp_from_spot(from_spot)
    from_spot ? "景区" : "旅行社"
  end

  def show_adult_purchase_price_for_individual_rate(individual_rate)
    individual_rate&&
        "#{individual_rate.adult_purchase_price}" || "--"
  end

  def show_adult_sale_price_for_individual_rate(individual_rate)
    individual_rate&&
        "#{individual_rate.adult_sale_price}" || "--"
  end

  def show_child_purchase_price_for_individual_rate(individual_rate)
    individual_rate&&
        "#{individual_rate.child_purchase_price}" || "--"
  end

  def show_child_sale_price_for_individual_rate(individual_rate)
    individual_rate&&
        "#{individual_rate.child_sale_price}" || "--"
  end

  def show_adult_price_for_team_rate(team_rate)
    team_rate&&
        "#{team_rate.adult_price}" || "--"
  end

  def show_child_price_for_team_rate(team_rate)
    team_rate&&
        "#{team_rate.child_price}" || "--"
  end

  def show_agent_or_spot_name()
    if current_user && current_user.is_spot_user
      "#{current_user.spot.name}"
    elsif current_user && current_user.is_agent_user
      "#{current_user.agent.name}"
    end
  end

  def show_in_or_out_for_spot(item)
    if(item.payment_method == 'poa' && item.type == "IndividualReservation")
      '应付'
    else
      '应收'
    end
  end

  def show_in_or_out_for_agent(item)
    if(item.payment_method == 'poa' && item.type == "IndividualReservation")
      '应收'
    else
      '应付'
    end
  end

  def button_to_link(value, action, options)
    content_tag(:input,nil,{:type => :button, :value => value,:onclick=>"window.location=\"#{action}\""}.merge(options)  )
  end

end
