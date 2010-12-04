class RemoveUnusedTalkColumns < ActiveRecord::Migration
  def self.up
    remove_column :talks, :slideshare_url
    remove_column :talks, :red_votes
    remove_column :talks, :yellow_votes
    remove_column :talks, :green_votes
  end

  def self.down
    add_column :talks, :slideshare_url, :string
    add_column :talks, :red_votes, :integer
    add_column :talks, :yellow_votes, :integer
    add_column :talks, :green_votes, :integer
  end
end
