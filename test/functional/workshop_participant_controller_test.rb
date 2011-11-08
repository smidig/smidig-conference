require 'test_helper'

class WorkshopParticipantControllerTest < ActionController::TestCase
  setup do
    login_as :quentin
  end
  
  test "should get index" do
    get :index, :talk_id => talks(:workshop_by_quentin).id
    assert_response :success
    assert_not_nil assigns(:participants)
  end

  test "should create participant" do
    assert_difference('WorkshopParticipant.count') do
      post :create, :talk_id => talks(:workshop_by_god).id, :workshop_participant => { }
      assert_redirected_to talk_path(assigns(:talk))
    end
  end

  test "should destroy participant" do
    assert_difference('WorkshopParticipant.count', -1) do
      delete :destroy, :talk_id => talks(:workshop_by_god_with_quentin).id,
              :id => workshop_participants(:quentin_at_gods_workshop).id
      assert_redirected_to talk_path(assigns(:talk))
    end
  end
end
