require 'test_helper'

class TopicsControllerTest < ActionController::TestCase

  def test_tull
    assert true
  end
#  def test_anybody_can_get_index
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:topics)
#  end
#
#  def test_anybody_can_show_topic
#    get :show, :id => topics(:one).id
#    assert_response :success
#  end
#
#  def test_registered_users_should_get_new
#    login_as :quentin
#    get :new
#    assert_response :success
#  end
#
#  def test_registered_users_should_create_topic
#    login_as :quentin
#    assert_difference('Topic.count') do
#      post :create, :topic => { :title => 'foo', :description => 'bar' }
#    end
#
#    assert_redirected_to topic_path(assigns(:topic))
#  end
#
#  def test_admins_can_edit
#    login_as :god
#    get :edit, :id => topics(:one).id
#    assert_response :success
#  end
#
#  def test_admins_can_update_topic
#    login_as :god
#    put :update, :id => topics(:one).id, :topic => { }
#    assert_redirected_to topic_path(assigns(:topic))
#  end
#
#  def test_only_admins_can_destroy_topic
#    login_as :god
#    assert_difference('Topic.count', -1) do
#      delete :destroy, :id => topics(:one).id
#    end
#
#    assert_redirected_to topics_path
#  end
#
#  def test_nonusers_cannot_destroy_or_update_topics
#    assert_no_difference('Topic.count', -1) do
#      delete :destroy, :id => topics(:one).id
#    end
#    assert_redirected_to new_user_session_path
#
#    put :update, :id => topics(:one).id, :topic => { }
#    assert_redirected_to new_user_session_path
#  end
#
#  def test_others_cannot_destroy_or_update_topics
#    login_as :other
#    assert_no_difference('Topic.count', -1) do
#      delete :destroy, :id => topics(:one).id
#    end
#    assert_redirected_to new_user_session_path
#
#    put :update, :id => topics(:one).id, :topic => { }
#    assert_redirected_to new_user_session_path
#  end
end
