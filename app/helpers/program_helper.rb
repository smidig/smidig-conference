module ProgramHelper
  def timeslot_with_location_tr(timeslot, periods)
    """
    <tr><td class='time'>#{timeslot}</td> 
        <td class='slot salA'>
            <div class='event'>#{period_title(periods[0])}</div>
            <span class='location'>Sal A</span>
        </td>
        <td class='slot salB'>
            <div class='event'>#{period_title(periods[1])}</div>
            <span class='location'>Sal B</span>
        </td>
        <td class='slot salC'>
          <div class='event'>#{period_title(periods[2])}</div>
            <span class='location'>Sal C</span>
        </td>
    </tr> 
    """
  end

  def timeslot_tr(timeslot, periods)
    """
    <tr><td class='time'>#{timeslot}</td> 
        <td class='slot salA'><div class='event'>#{period_title(periods[0])}</div></td>
        <td class='slot salB'><div class='event'>#{period_title(periods[1])}</div></td>
        <td class='slot salC'><div class='event'>#{period_title(periods[2])}</div></td>
    </tr> 
    """
  end

  
  
  
  def period_title(period)
    period.title.blank? ? 'Ikke navngitt' : period.title
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
