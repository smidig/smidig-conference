class SmidigMailer < ActionMailer::Base
  

  def registration_confirmation(name, email, password, sent_at = Time.now)
    subject    'Smidig 2009 Bekreftelse brukerregistrering'
    recipients ''
    from       ''
    sent_on    sent_at
        
    body       :name => name, :email => email, :password => password
  end

  def payment_confirmation(sent_at = Time.now)
    subject    'SmidigMailer#payment_confirmation'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def talk_confirmation(sent_at = Time.now)
    subject    'SmidigMailer#talk_confirmation'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def comment_notification(sent_at = Time.now)
    subject    'SmidigMailer#comment_notification'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
