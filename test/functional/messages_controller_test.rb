require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_message
    assert_difference('Message.count') do
      post :create, :message => { }
    end

    assert_redirected_to message_path(assigns(:message))
  end

  def test_should_show_message
    get :show, :id => messages(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => messages(:one).id
    assert_response :success
  end

  def test_should_update_message
    put :update, :id => messages(:one).id, :message => { }
    assert_redirected_to message_path(assigns(:message))
  end

  def test_should_destroy_message
    assert_difference('Message.count', -1) do
      delete :destroy, :id => messages(:one).id
    end

    assert_redirected_to messages_path
  end
end
