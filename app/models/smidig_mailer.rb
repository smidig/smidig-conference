# -*- encoding : utf-8 -*-

class SmidigMailer < ActionMailer::Base

  default_url_options[:host] = "smidig2012.no"
  FROM_EMAIL = 'Smidig 2012 <kontakt@smidig.no>'
  SUBJECT_PREFIX = "[Smidig 2012]"

  default :from => FROM_EMAIL

  def promo_email(user)
    @name = user.name
    mail(:to => user.email,
         :subject => "Agile Lean Europe unconference i Berlin 7-9. september")
  end

  def registration_confirmation(user)
    @name = user.name
    @email = user.email
    mail(:to => user.email,
         :subject => "#{SUBJECT_PREFIX} Bruker #{user.email} er registrert")
  end

  def manual_registration_confirmation(user)
    @name = user.name
    @email = user.email
    mail(:to => user.email,
         :subject => "#{SUBJECT_PREFIX} Bruker #{user.email} er registrert")
  end

  def manual_registration_notification(user, user_url)
    @name = user.name
    @email = user.email
    @description = user.registration.description
    @user_url = user_url
    mail(:to => FROM_EMAIL, :reply_to => "#{user.name} <#{user.email}>",
   :subject => "#{SUBJECT_PREFIX} Bruker #{user.email} har registrert seg med manuell betalingshåndtering")
  end

  def speaker_registration_confirmation(user)
    @name = user.name
    @email = user.email
    mail(:to => @email,
  :subject => "#{SUBJECT_PREFIX} Bruker #{user.email} er registrert")
  end

  def speaker_registration_notification(user, user_url)
    @name = user.name
    @email = user.email
    @user_url = user_url
    mail(:to => FROM_EMAIL, :reply_to => "#{user.name} <#{user.email}>",
         :subject => "#{SUBJECT_PREFIX} Bruker #{user.email} har registrert seg som foredragsholder.")
  end

  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(:to => user.email,
   :subject => "#{SUBJECT_PREFIX} Hvordan endre ditt passord")
  end

  def free_registration_confirmation(user)
    @name = user.name
    @email = user.email
    mail(:to => user.email,
   :subject => "#{SUBJECT_PREFIX} Bruker #{user.email} er registrert")
  end

  def free_registration_notification(user, user_url)
    @name = user.name
    @email = user.email
    @description = user.registration.description,
    @user_url = user_url
    mail(:to => FROM_EMAIL, :reply_to => "#{user.name} <#{user.email}>",
   :subject => "#{SUBJECT_PREFIX} Bruker #{user.email} har registrert seg som #{user.registration.description}")
  end

  def payment_confirmation(registration)
    @name = registration.user.name
    @payment_text = registration.description
    @amount = registration.price.to_i
    @mva = registration.price_mva
    mail(:to => registration.user.email,
   :subject => "#{SUBJECT_PREFIX} Betalingskvittering for #{registration.user.email}")
  end

  def talk_confirmation(talk, talk_url)
    @speaker = talk.speaker_name
    @email = talk.speaker_email
    @talk = talk.title
    @talk_url = talk_url
    mail(:to => talk.speaker_email,
         :subject => "#{SUBJECT_PREFIX} Bekreftelse på ditt bidrag #{talk.title}")
  end

  def comment_notification(comment, comment_url)
    @speaker = comment.talk.speaker_name
    @talk = comment.talk.title
    @comment_url = comment_url
    mail(:to => comment.talk.speaker_email,
   :subject => "#{SUBJECT_PREFIX} Kommentar til #{comment.talk.title}")
  end

  def talk_acceptance_confirmation(talk)
    @talk = talk.title
    @speaker = talk.speaker_name
    mail(:to => talk.speaker_email,
         :subject => "Ditt bidrag \"#{talk.title}\" har blitt akseptert")
  end

  def talk_refusation_confirmation(talk)
    @talk = talk.title
    @speaker = talk.speaker_name
    mail(:to => talk.speaker_email,
         :subject => "Ditt bidrag \"#{talk.title}\" har ikke kommet med")
  end

  def upload_slides_notification(talk, edit_talk_url, new_password_reset_url)
    @talk = talk.title
    @speaker_email = talk.speaker_email
    @speaker = talk.speaker_name
    @edit_talk_url = edit_talk_url
    @new_password_reset_url = new_password_reset_url
    mail(:to => talk.speaker_email,
   :subject => "Du kan nå laste opp slidene til ditt bidrag på Smidig 2012")
  end

  def error_mail(title, body)
    @body = body
    mail(:to => "dev@smidig.no", :subject => title)
  end

end
