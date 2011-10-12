# -*- encoding : utf-8 -*-
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
    should "be pending by default" do
      assert Talk.first.pending?
    end
    should "be accepted" do
      talk = Talk.first.accept!
      assert talk.accepted?
    end

    should "be refused" do
      talk = Talk.first.refuse!
      assert talk.refused?
    end

    should "not be refused nor pending if accepted" do
      talk = Talk.first.refuse!
      talk.accept!
      assert talk.accepted?
      assert !talk.refused?
      assert !talk.pending?
    end

    should "be able to regret" do
      talk = talks(:one).regret!
      assert talk.pending?
    end

    should "not list refused talks" do
      refused = talks(:one).refuse!
      talks(:two).accept!
      not_refused = Talk.all_pending_and_approved
      assert !not_refused.include?(refused)
      assert not_refused.size > 0
    end
  end


end
