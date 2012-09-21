class RemoveTordentaleFromTalkTypes < ActiveRecord::Migration
  def self.up
    thunder = TalkType.where(:name=>"Tordentale").first()
    lightning = TalkType.where(:name=>"Lyntale").first()
        
    Talk.where(:talk_type_id=>thunder.id).each { |talk| 
      talk.speakers.each { | speaker |
        puts User.find(speaker.user_id).email
      }
      talk.talk_type_id = lightning.id 
      talk.save!
    }
    
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
