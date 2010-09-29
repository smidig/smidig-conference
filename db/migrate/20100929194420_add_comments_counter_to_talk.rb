class AddCommentsCounterToTalk < ActiveRecord::Migration
  def self.up
    add_column :talks, :comments_count, :integer

    Talk.all.each do |talk|
      talk.comments_count = talk.comments.size
      puts "adding comment count #{talk.comments_count} to #{talk.title}"
      talk.save!
    end
  end

  def self.down
    remove_column :talks, :comments_count
  end
end
