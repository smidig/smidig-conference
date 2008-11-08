require 'test_helper'

class ContentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:contents)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_content
    assert_difference('Content.count') do
      post :create, :content => { }
    end

    assert_redirected_to content_path(assigns(:content))
  end

  def test_should_show_content
    get :show, :id => contents(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => contents(:one).id
    assert_response :success
  end

  def test_should_update_content
    put :update, :id => contents(:one).id, :content => { }
    assert_redirected_to content_path(assigns(:content))
  end

  def test_should_destroy_content
    assert_difference('Content.count', -1) do
      delete :destroy, :id => contents(:one).id
    end

    assert_redirected_to contents_path
  end
end
