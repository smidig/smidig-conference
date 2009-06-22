require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  
  def setup
    login_as :quentin
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:votes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_votes
    assert_difference('Vote.count') do
      post :create, :talk_id => talks(:one).id, :vote => { }
      assert_redirected_to talk_path(assigns(:talk))
    end
  end

  def test_should_show_vote
    get :show, :id => votes(:quentin_votes_for_two).id
    assert_response :success
  end

  def test_should_destroy_vote
    assert_difference('Vote.count', -1) do
      delete :destroy, :id => votes(:quentin_votes_for_two).id
    end

    assert_redirected_to votes_path
  end
end
