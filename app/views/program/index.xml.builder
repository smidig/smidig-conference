xml.Conference do |conf|
  
  for period in @periods
    for talk in period.talks
      conf.Session do |session|
        session.Id(talk.id)
        session.Copyright("Smidig 2010, Creative Commons BY 3.0")
        session.Title(talk.title)
        session.RecordingAlias(talk.id)
        session.Time("#{period.day} #{period.time_of_day}")
        session.Room case period.scene_id; when 0: "Sal A"; when 1: "Sal B"; when 2: "Sal C"; else "" end
        session.Speaker(talk.speaker_name)
      end
    end
  end
end