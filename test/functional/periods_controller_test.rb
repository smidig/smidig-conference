require 'test_helper'

class PeriodsControllerTest < ActionController::TestCase

  def setup
    login_as :quentin
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:periods)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_period
    assert_difference('Period.count') do
      post :create, :period => { }
    end

    assert_redirected_to period_path(assigns(:period))
  end

  def test_should_show_period
    get :show, :id => periods(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => periods(:one).id
    assert_response :success
  end

  def test_should_update_period
    put :update, :id => periods(:one).id, :period => { }
    assert_redirected_to period_path(assigns(:period))
  end

  def test_should_destroy_period
    assert_difference('Period.count', -1) do
      delete :destroy, :id => periods(:one).id
    end

    assert_redirected_to periods_path
  end
end
