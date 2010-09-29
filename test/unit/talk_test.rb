require 'test_helper'

class TalkTest < ActiveSupport::TestCase
  context "talk" do
    should_eventually "increment comments count when adding a comment" do
      talk = Talk.first
      comments_count = talk.comments_count
      talk.comments << Comment.create()
    end
  end


end
