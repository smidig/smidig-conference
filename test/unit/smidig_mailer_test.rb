require 'test_helper'

class SmidigMailerTest < ActionMailer::TestCase
  test "registration_confirmation" do
    @expected.subject = 'Smidig 2009 Bekreftelse brukerregistrering'
    @expected.body    = read_fixture('registration_confirmation')
    @expected.date    = Time.now
    
    name = "Ole Christian Rynning"
    email = "oc+smidig2009@rynning.no"
    password = "123qwe"

    assert_equal @expected.encoded, SmidigMailer.create_registration_confirmation(name, email, password, @expected.date).encoded
  end

  test "payment_confirmation" do
    @expected.subject = 'SmidigMailer#payment_confirmation'
    @expected.body    = read_fixture('payment_confirmation')
    @expected.date    = Time.now

    assert_equal @expected.encoded, SmidigMailer.create_payment_confirmation(@expected.date).encoded
  end

  test "talk_confirmation" do
    @expected.subject = 'SmidigMailer#talk_confirmation'
    @expected.body    = read_fixture('talk_confirmation')
    @expected.date    = Time.now

    assert_equal @expected.encoded, SmidigMailer.create_talk_confirmation(@expected.date).encoded
  end

  test "comment_notification" do
    @expected.subject = 'SmidigMailer#comment_notification'
    @expected.body    = read_fixture('comment_notification')
    @expected.date    = Time.now

    assert_equal @expected.encoded, SmidigMailer.create_comment_notification(@expected.date).encoded
  end

end
