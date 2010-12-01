class AddVoteToFeedbackVotes < ActiveRecord::Migration
  def self.up
    add_column :feedback_votes, :vote, :integer
  end

  def self.down
    remove_column :feedback_votes, :vote
  end
end
