module TopicsHelper
  def show_program_for_topic(topic, topic_offset)
    @topic = topic
    @topic_offset = topic_offset
    render :partial => 'topics/program' if @topic
  end

  def antall_lyntaler(antall)
    case antall
      when 0 then return "Ingen lyntaler"
      when 1 then return "1 lyntale"
      else return "#{antall} lyntaler"
    end
  end
end
