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
    assert_equal "accepted", Talk.find(@talk.id).acceptance_status
  end

  def test_accept_should_set_all_speakers_registrations_as_completed
    get :accept, :id => @talk.id
    for speaker in @talk.users
      assert_equal true, Registration.find(speaker.registration.id).registration_complete?
    end
  end

  def test_refuse_should_set_talk_as_refused
    get :refuse, :id => @talk.id
    assert_equal "refused", Talk.find(@talk.id).acceptance_status
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
end