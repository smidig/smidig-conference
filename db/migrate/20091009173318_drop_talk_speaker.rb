# -*- encoding : utf-8 -*-
class DropTalkSpeaker < ActiveRecord::Migration
  def self.up
    remove_column :talks, :speaker_id
  end

  def self.down
    add_column :talks, :speaker_id
    for talk in Talk.all
      talk.speaker = talk.users.first
    end
  end
end
