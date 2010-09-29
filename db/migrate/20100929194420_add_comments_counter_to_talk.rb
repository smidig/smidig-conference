class AddCommentsCounterToTalk < ActiveRecord::Migration
  def self.up
    add_column :talks, :comments_count, :integer

    Talk.all.each do |talk|
      Talk.update_counters(talk.id, :comments_count =>talk.comments.size)
    end

    #Visual confirmation
    Talk.all.each do |talk|
      puts "added comment count #{talk.comments_count} to #{talk.title}"
    end
  end

  def self.down
    remove_column :talks, :comments_count
  end
end
