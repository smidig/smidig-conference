class UserSession < Authlogic::Session::Base
  def self.login(username, password)
    user_session = UserSession.new
    user_session.email = username
    user_session.password = password      
    user_session.save
  end

  # http://www.dixis.com/?p=352
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
end
