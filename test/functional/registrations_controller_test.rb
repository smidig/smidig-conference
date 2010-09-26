require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  
  def test_admin_should_be_able_to_delete_registration
    login_as :god     
    assert_difference('Registration.count', -1) do
      delete :delete, :id => registrations(:one).id
    end

    assert_redirected_to registrations_path
  end
  
  def test_normal_user_cannot_delete_registrations
    login_as :quentin
    delete :delete, :id => registrations(:one).id
    assert_response 302
  end
  	
end