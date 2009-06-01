class Registration < ActiveRecord::Base
  belongs_to :user
  has_one :payment_notification
end
