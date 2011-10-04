# -*- encoding : utf-8 -*-
class Invoice < ActiveRecord::Base

  has_many :users

  def new_user_attributes=(user_attributes)
    user_attributes.each do |attributes|
      if attributes[:name].present?
        user = users.build attributes
        user.password = "dnmglksdngldsn"
        user.password_confirmation = user.password
        user.company = company_name
        user.registration = Registration.new
        user.registration.ticket_type = "early_bird" # TODO: Don't hardcode this
        user.registration.manual_payment = true
        # TODO @user.registration_ip = request.remote_ip
      end
    end
  end
  def existing_user_attributes=(user_attributes)
    users.reject(&:new_record?).each do |user|
      attributes = user_attributes[user.id.to_s]
      if attributes
        user.attributes = attributes
      else
        users.delete(user)
      end
    end
  end
  before_validation do
    for user in users
      user.company = self.company_name
    end
  end
  after_update do
    for user in users
      user.save(false)
    end
  end
end