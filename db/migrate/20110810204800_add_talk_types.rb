# -*- encoding : utf-8 -*-
class AddTalkTypes < ActiveRecord::Migration
  def self.up
    lightning_talk = TalkType.new
    lightning_talk.name = "Lyntale"
    lightning_talk.duration = "10 minutter"
    lightning_talk.save!

    thunder_talk = TalkType.new
    thunder_talk.name = "Tordentale"
    thunder_talk.duration = "20 minutter"
    thunder_talk.save!

    workshop = TalkType.new
    workshop.name = "Workshop"
    workshop.duration = "90 minutter"
    workshop.save!
  end

  def self.down
  end
end
