require 'test_helper'
require 'shoulda'

class UsersControllerTest < ActionController::TestCase

  def create_user_params
    {"accepted_privacy_guidelines"=>"0", "company"=>"Test", "name"=>"Test", "accept_optional_email"=>"0",
     "password_confirmation"=>"fjasepass", "phone_number"=>"92043382",
     "registration_attributes"=>
             {"ticket_type"=>"full_price", "manual_payment"=>"", "free_ticket"=>"false", "includes_dinner"=>"1"},
     "password"=>"fjasepass", "email"=>"ivarconr+test@gmail.com"}
  end

  context 'UsersController' do
    should "UsersController should be able to create user" do
      post :create, :user=> create_user_params()
      assert assign_to :user
    end
  end


end
