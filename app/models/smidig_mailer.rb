class SmidigMailer < ActionMailer::Base
  
  default_url_options[:host] = "smidig2010.no"
  FROM_EMAIL = 'Smidig 2010 <kontakt@smidig2010.no>'
  SUBJECT_PREFIX = "[Smidig 2010]"


  def registration_confirmation(user)
    subject    "#{SUBJECT_PREFIX} Bruker #{user.email} er registrert"
    recipients user.email
    from       FROM_EMAIL
    body       :name => user.name,
               :email => user.email
  end

  def manual_registration_confirmation(user)
    subject    "#{SUBJECT_PREFIX} Bruker #{user.email} er registrert"
    recipients user.email
    from       FROM_EMAIL
    body       :name => user.name,
               :email => user.email
  end

  def manual_registration_notification(user, user_url)
    subject    "#{SUBJECT_PREFIX} Bruker #{user.email} har registrert seg med manuell betalingshåndtering"
    recipients FROM_EMAIL
    from       FROM_EMAIL
    reply_to    "#{user.name} <#{user.email}>"
    body       :name => user.name,
               :email => user.email,
               :description => user.registration.description,
               :user_url => user_url
  end
  
  def password_reset_instructions(user)
    subject    "#{SUBJECT_PREFIX} Hvordan endre ditt passord"
    recipients user.email
    from       FROM_EMAIL
    body       :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
    
  end

  def free_registration_confirmation(user)
    subject    "#{SUBJECT_PREFIX} Bruker #{user.email} er registrert"
    recipients user.email
    from       FROM_EMAIL
    body       :name => user.name,
               :email => user.email
  end

  def free_registration_notification(user, user_url)
    subject    "#{SUBJECT_PREFIX} Bruker #{user.email} har registrert seg som #{user.registration.description}"
    recipients FROM_EMAIL
    from       FROM_EMAIL
    reply_to    "#{user.name} <#{user.email}>"        
    body       :name => user.name,
               :email => user.email,
               :description => user.registration.description,
               :user_url => user_url

  end

  def payment_confirmation(registration)
    subject    "#{SUBJECT_PREFIX} Betalingskvittering for #{registration.user.email}"
    recipients registration.user.email
    from       FROM_EMAIL
    body       :name => registration.user.name,
               :payment_text => registration.description,
               :amount => registration.price
  end

  def talk_confirmation(talk, talk_url)
    subject    "#{SUBJECT_PREFIX} Bekreftelse på foredrag #{talk.title}"
    recipients talk.users.map &:email
    from       FROM_EMAIL
    body       :speaker => talk.speaker_name,
               :email => talk.users.map(&:email).join(", "),
               :talk => talk.title,
               :talk_url => talk_url
  end

  def comment_notification(comment, comment_url)
    subject    "#{SUBJECT_PREFIX} Kommentar til #{comment.talk.title}"
    recipients comment.talk.users.map &:email
    from       FROM_EMAIL
    body       :speaker => comment.talk.speaker_name,
               :talk => comment.talk.title,
               :comment_url => comment_url
  end

end
