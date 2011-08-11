# -*- encoding : utf-8 -*-
class FeedbackVote < ActiveRecord::Base

  attr_accessor :alternatives

  has_one :talk
  belongs_to :feedback
end
