class TalksTags < ActiveRecord::Migration
  def self.up
    create_table :tags_talks, :id => false do |t|
      t.integer :talk_id
      t.integer :tag_id
    end
  end

  def self.down
    drop_table :tags_talks 
  end
end
