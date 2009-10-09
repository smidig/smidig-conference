class InsertSpeakers < ActiveRecord::Migration
  def self.up
    for talk in Talk.all
      talk.speakers.create :user_id => talk.speaker_id
    end
  end

  def self.down
    Speaker.delete :all
  end
end
