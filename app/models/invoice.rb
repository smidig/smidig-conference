# -*- encoding : utf-8 -*-
class Invoice < ActiveRecord::Base
  belongs_to :contact_user, :class_name => "User"
  has_many :registrations

  def contact_user_attributes=(contact_user_attributes)
    contact_user = User.new(contact_user_attributes)
  end

  def new_user_attributes=(user_attributes)
    user_attributes.each do |attributes|
      if attributes[:name].present?
        registration = Registration.new
        registration.ticket_type = "early_bird" # TODO: Don't hardcode this
        registration.manual_payment = true
        user = registration.user.build attributes
        user.password = "dnmglksdngldsn"
        user.password_confirmation = user.password
        user.company = company_name
        # TODO @user.registration_ip = request.remote_ip
      end
    end
  end
  def existing_user_attributes=(user_attributes)
    registrations.reject(&:new_record?).each do |registration|
      attributes = user_attributes[registration.id.to_s]
      if attributes
        registration.user.attributes = attributes
      else
        registrations.delete(registration)
      end
    end
  end
  before_validation do
    for registration in registrations
      registration.user.company = self.company_name
    end
  end
  after_update do
    for registration in registrations
      registration.user.save(false)
    end
  end
end
