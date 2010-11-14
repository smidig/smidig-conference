for registration in @registrations

  render :partial => 'registration',
      :locals => {:p_pdf => pdf, :registration => registration}

  pdf.start_new_page

end
