module ProgramHelper
  def timeslot_with_location_tr(timeslot, periods)
    """
    <tr><td class='time'>#{timeslot}</td> 
        <td class='slot salHelsingfors'>
            <div class='event'>#{periods[0].title}</div>
            <span class='location'>Helsingforssalen</span>
        </td>
        <td class='slot salStockholm'>
            <div class='event'>#{periods[1].title}</div>
            <span class='location'>Stockholmsalen</span>
        </td>
        <td class='slot salOslo'>
          <div class='event'>#{periods[2].title}</div>
            <span class='location'>Oslosalen</span>
        </td>
    </tr> 
    """.html_safe
  end


  def timeslot_tr(timeslot, periods)
    """
    <tr><td class='time'>#{timeslot}</td> 
        <td class='slot salHelsingfors'><div class='event'>#{periods[0].title}</div></td>
        <td class='slot salStockholm'><div class='event'>#{periods[1].title}</div></td>
        <td class='slot salOslo'><div class='event'>#{periods[2].title}</div></td>
    </tr> 
    """.html_safe
  end
  
  def timeslot_talks_phone_tr(periods)
    """
  <tr>
    <td></td>
    <td class='lyntaler salHelsingfors'>#{ period_talks_phone(periods[0])}</td>
    <td class='lyntaler salStockholm'>#{ period_talks_phone(periods[1])}</td>
    <td class='lyntaler salOslo'>#{ period_talks_phone(periods[2])}</td>
  </tr>
    """.html_safe
  end

  def timeslot_talks_tr(periods)
    """
  <tr>
    <td></td>
    <td class='lyntaler salHelsingfors'>#{ period_talks(periods[0])}</td>
    <td class='lyntaler salStockholm'>#{ period_talks(periods[1])}</td>
    <td class='lyntaler salOslo'>#{ period_talks(periods[2])}</td>
  </tr>
    """.html_safe
  end


  def period_talks_phone(period)
    "<ol>" + period.talks.collect { |t| "<li>#{t.speaker_name} - #{t.users.first.phone_number}</li>" }.join + "</ol>"
  end

  
  def period_talks(period)
    "<ol>" + period.talks.collect { |t| "<li>#{link_to h(t.title), t} (#{t.speaker_name})</li>" }.join + "</ol>"
  end
end
