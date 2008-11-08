class CreateTalks < ActiveRecord::Migration
  def self.up
    create_table :talks do |t|
      t.integer :speaker_id
      t.integer :topic_id
      t.string :title
      t.text :description
      t.string :slideshare_url
      t.boolean :presenting_naked
      t.string :video_url
      t.integer :position
      t.boolean :submitted
      t.integer :red_votes
      t.integer :yellow_votes
      t.integer :green_votes
      t.string :audience_level
      t.integer  :votes_count,  :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :talks
  end
end
