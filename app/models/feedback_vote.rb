# -*- encoding : utf-8 -*-
class FeedbackVote < ActiveRecord::Base

  attr_accessor :alternatives

  belongs_to :talk
end
