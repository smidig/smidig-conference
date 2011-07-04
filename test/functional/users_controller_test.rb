require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def create_user_params
    {"accepted_privacy_guidelines"=>"1", "company"=>"Test", "name"=>"Test", "accept_optional_email"=>"1",
     "password"=>"fjasepass", "password_confirmation"=>"fjasepass", "phone_number"=>"92043382",
     "registration_attributes"=> {"ticket_type"=>"full_price", "manual_payment"=>"", "free_ticket"=>"false", "includes_dinner"=>"1"},
     "email"=>"test@mail.com"}
  end

  def login_quentin
    q = users(:quentin)
    UserSession.create(q)
    q
  end

  context 'UsersController' do
    should "should be able to create user" do
      post :create, :user=> create_user_params()
      assert assign_to(:user)
      assert_nil flash[:notice]
      assert_nil flash[:error]
    end
    should 'enforce hard limit on user count' do
      User.expects(:count).returns(500)
      post :create, :user=> create_user_params()
      assert flash[:error]
    end
    context "with existing user" do
      should "be able to change dinner attendance" do
        q = login_quentin
        assert !q.attending_dinner?
        get :attending_dinner
        assert flash[:notice]
        assert_redirected_to current_users_path

      end
    end
  end


end
