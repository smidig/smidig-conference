class AddMultispeakerTalks < ActiveRecord::Migration
  def self.up
    Speaker.create! :user_id => 305, :talk_id => 82
    Speaker.create! :user_id => 177, :talk_id => 56
  end

  def self.down
    Speaker.delete_all :user_id => 177, :talk_id => 56
    Speaker.delete_all :user_id => 305, :talk_id => 82
  end
end
