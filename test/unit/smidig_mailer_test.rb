require 'test_helper'

class SmidigMailerTest < ActionMailer::TestCase
  test "registration_confirmation" do
    @expected.body    = read_fixture('registration_confirmation')

    user = User.new :email => "oc+smidig2009@rynning.no", :name => "Ole Christian Rynning"

    assert_equal @expected.body, SmidigMailer.create_registration_confirmation(user).body
  end

  test "payment_confirmation" do
    @expected.body    = read_fixture('payment_confirmation')

    user = User.new :email => "oc+smidig2009@rynning.no", :name => "Ole Christian Rynning"
    registration = Registration.new :user => user, :description => "Text", :price => 123.0

    assert_equal @expected.body, SmidigMailer.create_payment_confirmation(registration).body
  end

  test "talk_confirmation" do
    @expected.body    = read_fixture('talk_confirmation')

    user = User.new :email => "oc+smidig2009@rynning.no", :name => "Ole Christian Rynning"
    talk = Talk.new :speaker => user, :title => "A fine talk"
    talk_url = "http://smidig2009.no/talks/1234"

    assert_equal @expected.body, 
      SmidigMailer.create_talk_confirmation(talk, talk_url).body
  end

  test "comment_notification" do
    @expected.body    = read_fixture('comment_notification')

    user = User.new :email => "oc+smidig2009@rynning.no", :name => "Ole Christian Rynning"
    talk = Talk.new :speaker => user, :title => "A fine talk"
    comment = Comment.new :talk => talk
    comment_url = "http://smidig2009.no/talks/1234#comment_1"

    assert_equal @expected.body, SmidigMailer.create_comment_notification(comment, comment_url).body
  end

end
