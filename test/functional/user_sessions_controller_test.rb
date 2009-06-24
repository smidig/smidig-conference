require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  
  def test_should_block_restricted_pages_when_not_logged_in
    get :restricted
    assert !UserSession.find    
    
    login_as :quentin
    
    get :restricted
    assert UserSession.find
  end
  
  def test_should_login_and_logout
    login_as :quentin
    assert UserSession.find
    get :logout
    assert !UserSession.find
  end
  
    
end
