class UserSession < Authlogic::Session::Base
  def self.login(username, password)
    user_session = UserSession.new
    user_session.email = username
    user_session.password = password      
    user_session.save
  end
end