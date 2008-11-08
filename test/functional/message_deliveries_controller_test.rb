require 'test_helper'

class MessageDeliveriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:message_deliveries)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_message_delivery
    assert_difference('MessageDelivery.count') do
      post :create, :message_delivery => { }
    end

    assert_redirected_to message_delivery_path(assigns(:message_delivery))
  end

  def test_should_show_message_delivery
    get :show, :id => message_deliveries(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => message_deliveries(:one).id
    assert_response :success
  end

  def test_should_update_message_delivery
    put :update, :id => message_deliveries(:one).id, :message_delivery => { }
    assert_redirected_to message_delivery_path(assigns(:message_delivery))
  end

  def test_should_destroy_message_delivery
    assert_difference('MessageDelivery.count', -1) do
      delete :destroy, :id => message_deliveries(:one).id
    end

    assert_redirected_to message_deliveries_path
  end
end
