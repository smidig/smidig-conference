class PaymentNotification < ActiveRecord::Base
  belongs_to :registration
  serialize :params
  after_create :mark_registration_as_paid
  
  private
  
  def mark_registration_as_paid
    if status == "Completed"
     # cart.update_attribute(:purchased_at, Time.now)
    end
  end
end
