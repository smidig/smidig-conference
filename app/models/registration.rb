class Registration < ActiveRecord::Base
  belongs_to :user
  has_one :payment_notification
  
  def paid?
    payment_notification && payment_notification.status =="Completed"
  end
end
