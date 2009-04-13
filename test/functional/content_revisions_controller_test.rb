require 'test_helper'

class ContentRevisionsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  
  def setup
    login_as('quentin')
    @content_id = Content.find(:first).id
  end
  
  def test_should_get_index
    get :index, :content_id => @content_id
    assert_response :success
    assert_not_nil assigns(:content_revisions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_show_content_revision
    get :show, :id => content_revisions(:one).id, :content_id => @content_id
    assert_response :success
  end

end
