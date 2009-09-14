class Registration < ActiveRecord::Base
  belongs_to :user
  has_one :payment_notification
  
  def paid?
    payment_notification && payment_notification.status == "Completed"
  end
  
  def payment_url(payment_notifications_url, user_url)
  	values = {
      :business => PAYMENT_CONFIG[:paypal_email],
      :cmd => '_cart',
      :upload => '1',
      :currency_code => 'NOK',
      :notify_url => payment_notifications_url,
      :return => user_url,
      :invoice => id,
      :amount_1 => price,
      :item_name_1 => description,
      :item_number_1 => '1',
      :quantity_1 => '1'
    }
        
    PAYMENT_CONFIG[:paypal_url] +"?"+values.map do
          |k,v| "#{k}=#{CGI::escape(v.to_s)}"
    end.join("&")
  end
  
  # todo
  def generate_receipt_and_ticket(user, registration)  
    user.registration.receipt_link = receipt
    user.registration.save
  end

end
