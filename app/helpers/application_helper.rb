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
        "#{price_for_agent[ticket_id][:individual_rate].adult_sale_price}(" +
            "#{price_for_agent[ticket_id][:individual_rate].adult_purchase_price})" || "--"
  end

  def show_individual_child_price(price_for_agent, ticket_id)
    price_for_agent[ticket_id] && price_for_agent[ticket_id][:individual_rate] &&
        "#{price_for_agent[ticket_id][:individual_rate].child_sale_price}(" +
            "#{price_for_agent[ticket_id][:individual_rate].child_purchase_price})" || "--"
  end

  def show_team_adult_price(price_for_agent, ticket_id)
    price_for_agent[ticket_id] && price_for_agent[ticket_id][:team_rate] &&
        "#{price_for_agent[ticket_id][:team_rate].adult_price}" || "--"
  end

  def show_team_child_price(price_for_agent, ticket_id)
    price_for_agent[ticket_id] && price_for_agent[ticket_id][:team_rate] &&
        "#{price_for_agent[ticket_id][:team_rate].child_price}" || "--"
  end

  def show_reservation_type(reservation)
    if (reservation.type == "IndividualReservation")
      "散客票"
    else
      "团队票"
    end
  end

  def show_reservation_adult_price(reservation)
    if (reservation.type == "IndividualReservation")
      "#{reservation.adult_sale_price}(#{reservation.adult_purchase_price})"
    else
      "#{reservation.adult_price}"
    end
  end

  def show_reservation_child_price(reservation)
    if (reservation.type == "IndividualReservation")
      "#{reservation.child_sale_price}(#{reservation.child_purchase_price})"
    else
      "#{reservation.child_price}"
    end
  end

  def show_reservation_total_price(reservation)
    if (reservation.type == "IndividualReservation")
      "#{reservation.total_price}(#{reservation.total_purchase_price})"
    else
      "#{reservation.total_price}"
    end
  end

  def date_format(date)
      date.strftime("%Y-%m-%d")
  end
end
