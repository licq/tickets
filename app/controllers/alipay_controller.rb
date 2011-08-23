require "open-uri"
class AlipayController < ApplicationController
  @@gateway = "https://mapi.alipay.com/gateway.do?"

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
        "seller_email" => spot.email,
        "anti_phishing_key" => query_timestamp(spot.account)
    }

    parameter["sign"] = calculate_sign(parameter, spot.key)
    parameter["sign_type"] = "MD5"
    redirect_to create_url(parameter)
  end

  def return
    reservation = Reservation.find(params[:out_trade_no])
    if reservation.present? && verify_sign(params,reservation.spot.key)
       reservation.paid= true
      reservation.save!
    end
  end

  def notify

  end

  protected

  def verify_sign(params, spot_key)
    calculate_sign(params.reject{|key,value| key =~ /^sign/},spot_key) == params[:sign]
  end

  def calculate_sign(params, spot_key)
    sign((Hash[params.sort].map { |key, value| key + "=" + value }).join("&") + spot_key)
  end

  def create_url(parameter)
    @@gateway + (parameter.map { |key, value| key + "=" + URI.escape(value) }).join("&")
  end

  def sign(prestr)
    Digest::MD5.hexdigest(prestr)
  end

  def query_timestamp(account)
    doc = Nokogiri::HTML(open(@@gateway + "service=query_timestamp&partner=" + account))
    doc.at_css("encrypt_key").content
  end
end
