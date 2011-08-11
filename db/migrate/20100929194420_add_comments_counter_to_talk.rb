class AddCommentsCounterToTalk < ActiveRecord::Migration
  def self.up
    add_column :talks, :comments_count, :integer
  end

  def self.down
    remove_column :talks, :comments_count
  end
end
