p_pdf.font_families.update(
    "League Gothic" => { :normal => "#{Rails.root}/public/stylesheets/League_Gothic-webfont.ttf" },
    "Blackout" => { :normal => "#{Rails.root}/public/stylesheets/Blackout-Midnight-webfont.ttf" }
)

p_pdf.font 'Blackout'
p_pdf.fill_color 'f0f0f0'
p_pdf.text '2010',
    :at => [20,-20],
    :overflow => :truncate,
    :size => 240

p_pdf.font 'League Gothic'
p_pdf.fill_color 'cc0000'

name = registration.user.name
company = registration.user.company


if (registration.ticket_type == 'organizer' || registration.ticket_type == 'volunteer') and company.downcase == 'cisco'
  p_pdf.text 'Filmcrew',
      :at => [315,20],
      :size => 36

elsif registration.ticket_type == 'organizer'
  p_pdf.text 'Arrangør',
      :at => [315,20],
      :size => 36

elsif registration.ticket_type == 'volunteer'
  p_pdf.text 'Frivillig',
      :at => [320,20],
      :size => 36
end

p_pdf.fill_color '000000'
p_pdf.text name,
    :size => (name.length <= 20) ? 60 : 44,
    :at => [20,230]

p_pdf.text company,
    :size => 36,
    :at => [20,190]