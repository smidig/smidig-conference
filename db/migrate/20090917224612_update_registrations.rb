# -*- encoding : utf-8 -*-
class UpdateRegistrations < ActiveRecord::Migration
  def self.up
    for registration in Registration.all
      if !registration.user && !registration.paid?
        registration.delete
        next
      elsif !registration.user
        puts "Missing user for registration #{registration.id}"
        next
      end
        
      registration.ticket_type =
        (registration.user.is_admin ? "organizer" : !registration.user.talks.empty? ? "speaker" : registration.is_earlybird ? "early_bird" : "full_price")
      registration.registration_complete = false
      if payment_notification = registration.payment_notification
        registration.payment_notification_params = payment_notification.params
        registration.paid_amount = payment_notification.paid_amount.to_i
        registration.payment_reference = payment_notification.transaction_id
        registration.registration_complete = registration.paid_amount == registration.price
        registration.payment_complete_at = payment_notification.created_at
      end
      registration.save!
    end
    
    for user in User.all
      unless user.registration
        if user.is_admin
          user.create_registration(:ticket_type => "organizer")
          user.registration.created_at = user.created_at
          user.registration.registration_complete = true
          user.registration.save!
        elsif !user.talks.empty?
          user.create_registration(:ticket_type => "speaker")
          user.registration.created_at = user.created_at
          user.registration.registration_complete = false
          user.save!
        else
          puts "Missing registration for #{user.name}"
        end
      end
    end
  end

  def self.down
  end
end
