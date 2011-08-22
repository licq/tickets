class AlipayController < ApplicationController
  @@gateway = "https://www.alipay.com/cooperate/gateway.do?"

  def pay
    reservation = Reservation.find(params[:id])
    spot = reservation.spot
    parameter = {
        "service" => "create_direct_pay_by_user",
        "partner" => spot.account,
        "return_url" => return_alipay_index_url,
        "notify_url" => notify_alipay_index_url,
        "_input_charset" => "utf-8",
        "subject" => spot.name + "--" + reservation.ticket_name,
        "out_trade_no" => reservation.no,
        "payment_type" => "1",
        "total_fee" => "0.01",
        "seller_email" => spot.email
    }

    parameter["sign"] = calculate_sign(parameter,spot.key)
    parameter["sign_type"] = "MD5"
    @link=create_url(parameter)
  end

  def return

  end

  def notify

  end

  protected

  def calculate_sign(parameter, spot_key)
    sign((Hash[parameter.sort].map{|key,value| key + "=" + value}).join("&") + spot_key)
  end

  def create_url(parameter)
    @@gateway + (parameter.map{|key,value| key + "=" + URI.escape(value)}).join("&")
  end

  def sign(prestr)
    Digest::MD5.hexdigest(prestr)
  end
end
