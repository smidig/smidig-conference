class CreateFeedbackVotes < ActiveRecord::Migration
  def self.up
    create_table :feedback_votes do |t|
      t.references :talk
      t.references :feedback
      t.string :comment
    end
  end

  def self.down
    drop_table :feedback_votes
  end
end
