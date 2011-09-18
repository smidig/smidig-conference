# -*- encoding : utf-8 -*-
class InvitationMailer < ActionMailer::Base

  def invitation_mail(email)
    recipients "<#{email}>"
    from       "Smidig konferansen"
    subject    "Vil du være med på Smidig 2011?"
    sent_on    Time.now
  end

end
