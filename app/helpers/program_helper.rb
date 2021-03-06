# -*- encoding : utf-8 -*-
module ProgramHelper
  def timeslot_with_location_tr(timeslot, periods)
    """
    <tr><td class='time'>#{timeslot}</td> 
        <td class='slot salOlympia'>
            <div class='event'>#{periods[0].title}</div>
            <span class='location'>Olympia</span>
        </td>
        <td class='slot salFilm'>
            <div class='event'>#{periods[1].title}</div>
            <span class='location'>Film</span>
        </td>
        <td class='slot salKunst'>
          <div class='event'>#{periods[2].title}</div>
            <span class='location'>Kunst</span>
        </td>
    </tr> 
    """.html_safe
  end


  def timeslot_tr(timeslot, periods)
    """
    <tr><td class='time'>#{timeslot}</td> 
        <td class='slot salOlympia'><div class='event'>#{periods[0].title}</div></td>
        <td class='slot salFilm'><div class='event'>#{periods[1].title}</div></td>
        <td class='slot salKunst'><div class='event'>#{periods[2].title}</div></td>
    </tr> 
    """.html_safe
  end
  
  def timeslot_talks_phone_tr(periods)
    """
  <tr>
    <td></td>
    <td class='lyntaler salOlympia'>#{ period_talks_phone(periods[0])}</td>
    <td class='lyntaler salFilm'>#{ period_talks_phone(periods[1])}</td>
    <td class='lyntaler salKunst'>#{ period_talks_phone(periods[2])}</td>
  </tr>
    """.html_safe
  end

  def timeslot_talks_tr(periods)
    """
  <tr>
    <td></td>
    <td class='lyntaler salOlympia'>#{ period_talks(periods[0])}</td>
    <td class='lyntaler salFilm'>#{ period_talks(periods[1])}</td>
    <td class='lyntaler salKunst'>#{ period_talks(periods[2])}</td>
  </tr>
    """.html_safe
  end  

  def timeslot_workshops_tr(workshops)
    html = """
  <tr>
    <td></td>
    <td class='lyntaler workshop salOlympia'>#{ period_workshops(workshops[0])}</td>
    <td class='lyntaler workshop salOlympia'>#{ period_workshops(workshops[1])}</td>
    <td>&nbsp;</tid>
  </tr>
    """.html_safe
    if (logged_in)
      html += """
    <tr>
      <td></td>
      <td class='lyntaler workshop salOlympia'>#{ workshop_participation_link(workshops[0], current_user)}#{ workshop_stats(workshops[0]) if admin?}</td>
      <td class='lyntaler workshop salOlympia'>#{ workshop_participation_link(workshops[1], current_user)}#{ workshop_stats(workshops[1]) if admin?}</td>
      <td>&nbsp;</tid>
    </tr>
      """.html_safe
    end
    html
  end


  def period_talks_phone(period)
    "<ol>" + period.talks.sort_by(&:position).collect { |t| "<li>#{t.speaker_name} - #{t.users.first.phone_number}</li>" }.join + "</ol>"
  end

  def abbr_for_talk(talk_type)
    if(talk_type == "lang workshop")
      "(WS) "
    elsif talk_type == "kort workshop"
      "(WS) "
    else
      ""
    end
  end
  
  def period_talks(period)
    "<ol>" + period.talks.sort_by(&:position).collect { |t| "<li class='#{t.talk_type.name.downcase}'>#{abbr_for_talk(t.talk_type.name.downcase)}#{link_to h(t.title), t} (#{t.speaker_name})<br />#{t.talk_type.duration}</li>" }.join + "</ol>"
  end  


  def period_workshops(workshop)
    "#{link_to h(workshop.title), workshop}<br /> #{workshop.speaker_name}"
  end

  def render_talk(t)
    "<div class='talk' data-talkid='#{t.id}'>
      <h3 title='(#{t.id}) #{t.title}'>#{abbr_for_talk(t.talk_type.name.downcase)}#{t.title}</h3>
      <span class='author'>#{t.speaker_name}</span>
      <div class='description'>#{simple_format h(t.description)}</div>
    </div>".html_safe
  end

  def workshop_link(t)
    link_to("Påmelding", t)
  end



  def render_ws(t)
    "<div class='talk' data-talkid='#{t.id}'>
      <h3>#{t.title}</h3>
      <span class='author'>#{t.speaker_name}</span>
      <div class='description'>#{simple_format h(t.description)}
      <p>#{workshop_link(t)}</p>
      </div>
    </div>".html_safe
  end

  def period_talks_slot(period)
    "<div class='slot'>" + period.talks.sort_by(&:position).collect { |t| "#{render_talk(t)}"}.join + "</div>"
  end 

  def sal_name(id) 
    if id == 0 
      return "Olympia"
    elsif id == 1 
      return "Film"
    else 
      return "Kunst"
    end
      
  end

  def timeslot_talks_section(period, index)
    last = index == 2 ? "last" : ""
    """
      <section class='period sal_#{period.scene_id} fourcol #{last}'>
      <header>
        <span class='location'>#{sal_name(period.scene_id)}</span>
        <time class='time'>#{period.time_of_day}</time>
      </header>
      #{period_talks_slot(period)}
      </section>
    """.html_safe
  end

  def timeslot_talks_row(periods)
    html = "<div class='row'><h3 class='time'>#{periods[0].day}, #{periods[0].time_of_day}</h3>"
    periods.each do |index, period|
      html += timeslot_talks_section(period, index)
    end

    html += "</div>"
    html.html_safe
  end  
  
end
