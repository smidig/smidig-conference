namespace :infomail do
  task :mail_settings => :environment do
    include ActionController::UrlWriter
    default_url_options[:host] = 'smidig2010.no'
  end

  task :sent_email do
    raise "This email has already been sent!"
  end

  task :unready_email do
    raise "This email is not ready to be sent yet!"
  end

  desc "Send out information about a related event"
  task :send_promo_mail => :sent_email do
    users = User.all.select { |u| u.accept_optional_email? }
    for user in users
      #next unless user.email == 'jb@steria.no'
      print "Mailing: #{user.email}..."
      SmidigMailer.deliver_promo_email(user)
      puts " done"
    end
    puts "Sent all #{users.count} mails"
  end

  desc "Send out request for speakers to upload slides"
  task :upload_slides_notification => :sent_email do
    talks = Talk.all(:conditions => {:acceptance_status => 'accepted'})
    for talk in talks
      #next unless talk.speaker_email == 'jb@steria.no'

      print "Mailing: #{talk.speaker_email} #{talk.title}....."
      SmidigMailer.deliver_upload_slides_notification(talk, edit_talk_url(talk), new_password_reset_url)
      puts " done"
    end
    puts "Sent all #{talks.count} mails"
  end

  desc "Send out request for dinner attendance update"
  task :update_dinner_attendance_mail => :sent_email do
    count = User.count
    puts "Sending #{count} mails requesting to update dinner attendance"
    User.all.each do |user|
      next unless user.email == 'ole.morten.amundsen@gmail.com'

      puts "Mailing to #{user.email}"
      SmidigMailer.deliver_update_dinner_attendance_status(user.name, user.email, attending_dinner_url, not_attending_dinner_url)
    end
    puts "Sent all #{count} mails"
  end

  desc "Send out information before the conference starts"
  task :welcome_to_the_conference => :sent_email do
    users = User.all
    for user in users
      #next unless user.email == 'ole.morten.amundsen@gmail.com'
      next if not user.registration.registration_complete?
      #next unless user.email == 'jb@steria.no'

      print "Mailing: #{user.email}..."
      SmidigMailer.deliver_welcome_email(user)
      puts " done"
    end
    puts "Sent all #{users.count} mails"
  end


  desc "Send out feedback mails to speakers"
  task :feedback_mail => :mail_settings do
    talks = Talk.all(:include => [:users, :feedback_comments], :conditions => "acceptance_status = 'accepted'")
    averages = talks.map { |talk| (talk.average_feedback_score) }
    calc = PercentileCalculator.new(averages)

    for talk in talks
      #next unless talk.users[0].email == 'karianne.berg@gmail.com'

      puts "Mailing: #{talk.speaker_name}..."

      group = calc.find_group(talk.average_feedback_score)
      SmidigMailer.deliver_feedback_email(talk, group)
    end
  end

end

