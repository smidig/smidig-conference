require 'test_helper'

class WorkshopParticipantHelperTest < ActionView::TestCase
  context "workshop_participation_link" do
    setup do
      @quentin = users(:quentin)
    end

    should "link join" do
      talk = talks(:workshop_by_god)
      html = workshop_participation_link(talk, @quentin)
      assert_match /join-workshop/, html
    end

    should "link leave" do
      talk = talks(:workshop_by_god_with_quentin)
      html = workshop_participation_link(talk, @quentin)
      assert_match /leave-workshop/, html
    end

    should "not link to full workshop" do
      talk = talks(:workshop_by_god)
      talk.expects(:"complete?").returns(true)
      html = workshop_participation_link(talk, @quentin)
      assert_match /workshop-full/, html
    end

  end
end
