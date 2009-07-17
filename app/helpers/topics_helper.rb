module TopicsHelper
  def show_program_for_topic(topic, topic_offset)
    @topic = topic
    @topic_offset = topic_offset
    render :partial => 'topics/program' if @topic
  end

  def antall_lyntaler(antall)
    case antall
      when 0 then return "Ingen lyntaler foreslått enda"
      when 1 then return "1 lyntale foreslått"
      else return "#{antall} lyntaler foreslått"
    end
  end
  
  def antall_flere_lyntaler(antall_flere)
    case antall_flere
      when -100..0 then return ""
      when 1 then return "1 lyntale til foreslått"
      else return "#{antall_flere} flere lyntaler foreslått"
    end    
  end
end
