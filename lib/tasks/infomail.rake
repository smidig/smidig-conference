
namespace :infomail do

  desc "Send out request for speakers to upload slides"
  task :upload_slides_notification do
    require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
    include ActionController::UrlWriter
    default_url_options[:host] = 'smidig2010.no'

    for talk in Talk.all(:conditions => {:acceptance_status => 'accepted'}, :include => {:speakers => :user})
      next unless talk.speaker_email == 'jb@steria.no'

      puts "Mailing: #{talk.title}"
      SmidigMailer.deliver_upload_slides_notification(talk, edit_talk_url(talk), new_password_reset_url)
      puts "Mailed: #{talk.speaker_email} #{talk.title}"
    end
  end

  desc "Send out request for dinner attendance update"
  task :update_dinner_attendance_mail do
    require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
    include ActionController::UrlWriter
    default_url_options[:host] = 'smidig2010.no'
    puts "Sending #{User.count} mails requesting to update dinner attendance"
    User.all.each do |user|
      next unless user.email == 'ole.morten.amundsen@gmail.com'
      puts "Mailing to #{user.email}"
      SmidigMailer.deliver_update_dinner_attendance_status(user.name, user.email, attending_dinner_url, not_attending_dinner_url)
    end
    puts "Sent all #{User.count} mails"


  end

end
