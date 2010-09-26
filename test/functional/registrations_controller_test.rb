require 'test_helper' 

class RegistrationsControllerTest < ActionController::TestCase
  
  def test_admin_should_be_able_to_delete_registration
    login_as :god     
    assert_difference('Registration.count', -1) do
      delete :delete, :id => registrations(:one).id, :name => "John H. Example", :confirmation => "joh"
    end

    assert_redirected_to registrations_path
  end
  
  def test_normal_user_cannot_delete_registrations
    login_as :quentin
    delete :delete, :id => registrations(:one).id, :name => "John H. Example", :confirmation => "joh"
    assert_response 302
  end
  
  def test_normal_user_cannot_view_may_delete
    login_as :quentin
    get :confirm_delete, :id => registrations(:one).id
    assert_response 302
  end
  
  def test_first_three_letters_in_name_and_confirmation_must_be_alike
    login_as :god
    assert_no_difference('Registration.count') do
      delete :delete, :id => registrations(:one).id, :name => "John H. Example", :confirmation => "jjj"
    end
    
    assert_not_nil flash[:error]
  end
  
  def test_should_not_delete_talks_that_have_several_speakers_when_deleting_one_user
    login_as :god
    assert_no_difference('Talk.count') do
      delete :delete, :id => registrations(:one).id, :name => "John H. Example", :confirmation => "joh"
    end
  end
  	
end