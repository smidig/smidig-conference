# -*- encoding : utf-8 -*-
require 'test_helper'
require 'pp'

class AcceptancesControllerTest < ActionController::TestCase

  def setup
    login_as(:god)
    @talk = talks(:three)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:talks)
  end

  def test_accept_should_set_talk_as_accepted
    get :accept, :id => @talk.id
    assert Talk.find(@talk.id).accepted?
  end

  def test_accept_should_set_all_speakers_registrations_as_completed
    get :accept, :id => @talk.id
    for speaker in @talk.users
      assert_equal true, Registration.find(speaker.registration.id).registration_complete?
    end
  end

  def test_accept_of_user_with_completed_registration_will_not_alter_ticket_type
    @talk = talks(:five)
    get :accept, :id => @talk.id
    assert_equal "sponsor", Registration.find(@talk.users[0].registration.id).ticket_type
  end

  def test_refuse_should_set_talk_as_refused
    get :refuse, :id => @talk.id
    assert Talk.find(@talk.id).refused?
  end

  def test_refuse_last_talk_sets_speakers_ticket_type_to_paying
    get :refuse, :id => @talk.id
    assert_equal "full_price", Registration.find(@talk.users[0].registration.id).ticket_type
  end

  def test_refuse_talk_with_other_talks_pending_does_not_alter_speakers_ticket_type
    @talk = talks(:four)
    get :refuse, :id => @talk.id
    assert_equal "speaker", Registration.find(@talk.users[0].registration.id).ticket_type
  end

  def test_refusal_of_user_with_special_ticket_will_not_alter_ticket_type
    @talk = talks(:five)
    get :refuse, :id => @talk.id
    assert_equal "sponsor", Registration.find(@talk.users[0].registration.id).ticket_type
  end

  def test_await_rolls_back_ticket_type_for_normal_users
    @talk = talks(:one)
    get :await, :id => @talk.id
    assert_equal "speaker", Registration.find(@talk.users[0].registration.id).ticket_type
    assert_equal false, Registration.find(@talk.users[0].registration.id).registration_complete
  end

  def test_await_does_not_roll_back_ticket_type_for_special_users
    @talk = talks(:five)
    get :await, :id => @talk.id
    assert_equal "sponsor", Registration.find(@talk.users[0].registration.id).ticket_type
  end
end
