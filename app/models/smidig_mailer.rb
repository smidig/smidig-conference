class SmidigMailer < ActionMailer::Base
  
  default_url_options[:host] = "smidig2009.no"


  def registration_confirmation(user)
    subject    "[Smidig 2009] Bruker #{user.email} er registrert"
    recipients user.email
    from       'Smidig 2009 <kontakt@smidig2009.no>'        
    body       :name => user.name,
               :email => user.email
  end

  def manual_registration_confirmation(user)
    subject    "[Smidig 2009] Bruker #{user.email} er registrert"
    recipients user.email
    from       'Smidig 2009 <kontakt@smidig2009.no>'        
    body       :name => user.name,
               :email => user.email
  end

  def manual_registration_notification(user, user_url)
    subject    "[Smidig 2009] Bruker #{user.email} har registrert seg med manuell betalingshåndtering"
    recipients 'Smidig 2009 <kontakt@smidig2009.no>'
    from       'Smidig 2009 <kontakt@smidig2009.no>'
    reply_to    "#{user.name} <#{user.email}>"
    body       :name => user.name,
               :email => user.email,
               :description => user.registration.description,
               :user_url => user_url
  end
  
  def password_reset_instructions(user)
    subject    "[Smidig 2009] Hvordan endre ditt passord"
    recipients user.email
    from       'Smidig 2009 <kontakt@smidig2009.no>'
    body        :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
    
  end

  def free_registration_confirmation(user)
    subject    "[Smidig 2009] Bruker #{user.email} er registrert"
    recipients user.email
    from       'Smidig 2009 <kontakt@smidig2009.no>'        
    body       :name => user.name,
               :email => user.email
  end

  def free_registration_notification(user, user_url)
    subject    "[Smidig 2009] Bruker #{user.email} har registrert seg som #{user.registration.description}"
    recipients 'Smidig 2009 <kontakt@smidig2009.no>'
    from       'Smidig 2009 <kontakt@smidig2009.no>'
    reply_to    "#{user.name} <#{user.email}>"        
    body       :name => user.name,
               :email => user.email,
               :description => user.registration.description,
               :user_url => user_url

  end

  def payment_confirmation(registration)
    subject    "[Smidig 2009] Betalingskvittering for #{registration.user.email}"
    recipients registration.user.email
    from       'Smidig 2009 <kontakt@smidig2009.no>'        
    body       :name => registration.user.name,
               :payment_text => registration.description,
               :amount => registration.price
  end

  def talk_confirmation(talk, talk_url)
    subject    "[Smidig 2009] Bekreftelse på foredrag #{talk.title}"
    recipients talk.speaker.email
    from       'Smidig 2009 <kontakt@smidig2009.no>'        
    body       :speaker => talk.speaker.name,
               :email => talk.speaker.email,
               :talk => talk.title,
               :talk_url => talk_url
  end

  def comment_notification(comment, comment_url)
    subject    "[Smidig 2009] Kommentar til #{comment.talk.title}"
    recipients comment.talk.speaker.email
    from       'Smidig 2009 <kontakt@smidig2009.no>'        
    body       :speaker => comment.talk.speaker.name,
               :talk => comment.talk.title,
               :comment_url => comment_url
  end

end
