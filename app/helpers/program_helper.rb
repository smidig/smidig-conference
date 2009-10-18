module ProgramHelper
  def timeslot_with_location_tr(timeslot, periods)
    """
    <tr><td class='time'>#{timeslot}</td> 
        <td class='slot salA'>
            <div class='event'>#{periods[0].title}</div>
            <span class='location'>Sal A</span>
        </td>
        <td class='slot salB'>
            <div class='event'>#{periods[1].title}</div>
            <span class='location'>Sal B</span>
        </td>
        <td class='slot salC'>
          <div class='event'>#{periods[2].title}</div>
            <span class='location'>Sal C</span>
        </td>
    </tr> 
    """
  end

  def timeslot_tr(timeslot, periods)
    """
    <tr><td class='time'>#{timeslot}</td> 
        <td class='slot salA'><div class='event'>#{periods[0].title}</div></td>
        <td class='slot salB'><div class='event'>#{periods[1].title}</div></td>
        <td class='slot salC'><div class='event'>#{periods[2].title}</div></td>
    </tr> 
    """
  end
  
  def timeslot_talks_tr(periods)
    """
  <tr>
    <td></td>
    <td class='lyntaler salA'>#{ period_talks(periods[0])}</td>
    <td class='lyntaler salB'>#{ period_talks(periods[1])}</td>
    <td class='lyntaler salC'>#{ period_talks(periods[2])}</td>
  </tr>
    """
  end
  
  def period_talks(period)
    "<ol>" + period.talks.collect { |t| "<li>#{link_to h(t.title), t} (#{t.speaker_name})</li>" }.join + "</ol>"
  end
end
