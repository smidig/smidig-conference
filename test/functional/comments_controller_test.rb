require 'test_helper'

# for dom_id. Is there a better way?
require 'action_view/helpers/record_identification_helper'

class CommentsControllerTest < ActionController::TestCase
  include ActionView::Helpers::RecordIdentificationHelper	
  
  def setup
    login_as('quentin')
    @talk = Talk.find(:first) 
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  def test_should_create_comment
    assert_difference('Comment.count') do
      post :create, :comment => { :title => 'foo', :description => 'bar' }, :talk_id => @talk.id
    end

    assert_redirected_to talk_path(assigns(:talk), :anchor => dom_id(assigns(:comment)))
  end

end
