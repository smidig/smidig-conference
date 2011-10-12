# -*- encoding : utf-8 -*-
require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_mva
    r = registrations(:one)
    assert_equal 1875, r.price
    assert_equal 375, r.price_mva
  end
end
