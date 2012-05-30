# -*- encoding : utf-8 -*-
require 'test_helper'

class SmidigMailerTest < ActionMailer::TestCase
  test "registration_confirmation" do
    @expected.body    = read_fixture('registration_confirmation')

    user = User.new :email => "oc+smidig2011@rynning.no", :name => "Ole Christian Rynning"

    assert_equal @expected.body.encoded, SmidigMailer.registration_confirmation(user).body.encoded
  end

  test "payment_confirmation" do
    @expected.body    = read_fixture('payment_confirmation')

    user = User.new :email => "oc+smidig2011@rynning.no", :name => "Ole Christian Rynning"
    registration = user.create_registration :user => user,
      :ticket_type => "full_price", :includes_dinner => true
    registration.user = user

    assert_equal @expected.body.encoded, SmidigMailer.payment_confirmation(registration).body.encoded
  end

  test "talk_confirmation" do
    @expected.body    = read_fixture('talk_confirmation')

    user = User.new :email => "oc+smidig2011@rynning.no", :name => "Ole Christian Rynning"
    talk = Talk.new :title => "A fine talk"
    talk.users << user
    talk_url = "http://smidig2012.no/talks/1234"

    assert_equal @expected.body.encoded, 
      SmidigMailer.talk_confirmation(talk, talk_url).body.encoded
  end

  test "comment_notification" do
    @expected.body    = read_fixture('comment_notification')

    user = User.new :email => "oc+smidig2011@rynning.no", :name => "Ole Christian Rynning"
    talk = Talk.new :title => "A fine talk"
    talk.users << user
    comment = Comment.new :talk => talk
    comment_url = "http://smidig2012.no/talks/1234#comment_1"

    assert_equal @expected.body.encoded, SmidigMailer.comment_notification(comment, comment_url).body.encoded
  end

end
