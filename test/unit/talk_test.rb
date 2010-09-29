require 'test_helper'

class TalkTest < ActiveSupport::TestCase
  context "talk" do
    should "increment comments count when adding a comment" do
      talk = Talk.first
      talk_id = talk.id
      comments_count = talk.comments_count
      talk.comments << Comment.new(:title =>"en tittel", :description => "en beskrivelse", :user => User.last)
      talk = Talk.find(talk_id)
      assert_equal comments_count + 1, talk.comments_count
    end
  end
end
