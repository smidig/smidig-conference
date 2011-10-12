# -*- encoding : utf-8 -*-
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def test_user_attending_dinner
    quentin = users(:quentin)
#    quentin.stubs(:save).returns(true)
    assert !quentin.attending_dinner?
    quentin.attending_dinner!
    assert quentin.attending_dinner?
    #And testing the reverse in one go
    quentin.not_attending_dinner!
    assert !quentin.attending_dinner?
  end

  def test_user_with_one_pending_talk_does_not_have_all_talks_refused
    god = users(:god)
    assert god.all_talks_refused? == false
  end

  def test_user_with_one_refused_talk_has_all_talks_refused
    quentin = users(:quentin)
    assert quentin.all_talks_refused?
  end

  def test_early_user_gets_set_to_early_bird
    quentin = users(:quentin)
    quentin.update_to_paying_user
    assert_equal quentin.registration.ticket_type, "early_bird"
  end

  def test_late_user_gets_set_to_full_price
    god = users(:god)
    god.update_to_paying_user
    assert_equal god.registration.ticket_type, "full_price"
  end

end
