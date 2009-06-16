require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  
  def test_should_login_and_logout    
    get :restricted
    assert !UserSession.find    
    
    login_as :quentin
    
    get :restricted
    assert UserSession.find
    
    get :destroy
    assert !UserSession.find
  end
    
end
