require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

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
    talk_id = @talk.id
    assert_difference("Talk.find(#{talk_id}).comments_count", difference = 1) do
      assert_difference('Comment.count') do
        post :create, :comment => {:title => 'foo', :description => 'bar'}, :talk_id => talk_id
      end
    end
    assert_redirected_to talk_path(assigns(:talk), 
           :anchor => "comment_#{assigns(:comment).id}")
  end

end
