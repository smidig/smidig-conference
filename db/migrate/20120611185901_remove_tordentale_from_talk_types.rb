class RemoveTordentaleFromTalkTypes < ActiveRecord::Migration
  def self.up
  	thunder_talk = TalkType.where(:name=> "Tordentale").first
  	thunder_talk.delete
  end

  def self.down
  	thunder_talk = TalkType.new
    thunder_talk.name = "Tordentale"
    thunder_talk.duration = "20 minutter"
    thunder_talk.save!
  end
end
