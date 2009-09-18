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
      if payment_notification = registration.payment_notification
        registration.payment_notification_params = payment_notification.params
        registration.paid_amount = payment_notification.paid_amount
        registration.payment_reference = payment_notification.transaction_id
        registration.registration_complete = registration.paid_amount == registration.price
        registration.payment_complete_at = payment_notification.created_at
        registration.save!
      end
    end
    
    for user in User.all
      unless user.registration
        if user.is_admin
          user.create_registration(:ticket_type => "organizer", :created_at => user.created_at, :registration_complete => true)
          user.save!
        elsif !user.talks.empty?
          user.create_registration(:ticket_type => "speaker", :created_at => user.created_at, :registration_complete => false)
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
