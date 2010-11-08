
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

end
