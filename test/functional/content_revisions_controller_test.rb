require 'test_helper'

class ContentRevisionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:content_revisions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_content_revision
    assert_difference('ContentRevision.count') do
      post :create, :content_revision => { }
    end

    assert_redirected_to content_revision_path(assigns(:content_revision))
  end

  def test_should_show_content_revision
    get :show, :id => content_revisions(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => content_revisions(:one).id
    assert_response :success
  end

  def test_should_update_content_revision
    put :update, :id => content_revisions(:one).id, :content_revision => { }
    assert_redirected_to content_revision_path(assigns(:content_revision))
  end

  def test_should_destroy_content_revision
    assert_difference('ContentRevision.count', -1) do
      delete :destroy, :id => content_revisions(:one).id
    end

    assert_redirected_to content_revisions_path
  end
end
