class Registration < ActiveRecord::Base
  belongs_to :user
  has_one :payment_notification
  
  def paid?
    payment_notification && payment_notification.status =="Completed"
  end
  
  # todo
  def generate_receipt_and_ticket(user, registration)  
    user.registration.receipt_link = receipt
    user.registration.save
  end

end
