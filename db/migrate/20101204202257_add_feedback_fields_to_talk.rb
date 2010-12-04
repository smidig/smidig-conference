class AddFeedbackFieldsToTalk < ActiveRecord::Migration
  def self.up
    add_column :talks, :sum_of_votes, :integer
    add_column :talks, :num_of_votes, :integer
  end

  def self.down
    remove_column :talks, :sum_of_votes
    remove_column :talks, :num_of_votes
  end
end
