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
    """
  <tr>
    <td></td>
    <td class='lyntaler workshop salOlympia'>#{ period_workshops(workshops[0])}</td>
    <td class='lyntaler workshop salOlympia'>#{ period_workshops(workshops[1])}</td>
    <td>&nbsp;</tid>
  </tr>
  <tr>
    <td></td>
    <td class='lyntaler workshop salOlympia'>#{ workshop_participation_link(workshops[0], current_user)}</td>
    <td class='lyntaler workshop salOlympia'>#{ workshop_participation_link(workshops[1], current_user)}</td>
    <td>&nbsp;</tid>
  </tr>
    """.html_safe
  end


  def period_talks_phone(period)
    "<ol>" + period.talks.sort_by(&:position).collect { |t| "<li>#{t.speaker_name} - #{t.users.first.phone_number}</li>" }.join + "</ol>"
  end

  
  def period_talks(period)
    "<ol>" + period.talks.sort_by(&:position).collect { |t| "<li class='#{t.talk_type.name.downcase}'>#{link_to h(t.title), t} (#{t.speaker_name})<br />#{t.talk_type.duration}</li>" }.join + "</ol>"
  end  


  def period_workshops(workshop)
    "#{link_to h(workshop.title), workshop}<br /> #{workshop.speaker_name}"
  end
  
end
