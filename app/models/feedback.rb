class Feedback < ActiveRecord::Base
  has_many :feedback_votes

  def feedback_vote_attributes=(feedback_vote_attributes)
    feedback_vote_attributes.each do |attributes|
      feedback_votes.build(attributes)
    end
  end
end
