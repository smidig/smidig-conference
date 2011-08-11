# -*- encoding : utf-8 -*-

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
  
  def antall_flere_lyntaler(antall_flere, topic)
    text = "#{antall_flere} lyntaler til"
    case antall_flere
      when -100..0 then return ""
      when 1 then return "... og #{link_to 'en lyntale til', topic_path(topic, :anchor => 'talks') }"
      else return "... og #{link_to text, topic_path(topic, :anchor => 'talks')}"
    end    
  end
end
