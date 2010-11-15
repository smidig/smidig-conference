


p_pdf.font_families.update(
    "League Gothic" => { :normal => "#{Rails.root}/public/stylesheets/League_Gothic-webfont.ttf" },
    "Blackout" => { :normal => "#{Rails.root}/public/stylesheets/Blackout-Midnight-webfont.ttf" }
)

p_pdf.font 'Blackout'
p_pdf.fill_color 'f0f0f0'
p_pdf.text '2010',
    :at => [0,-30],
    :overflow => :truncate,
    :size => 160

p_pdf.font 'League Gothic'
p_pdf.fill_color 'cc0000'

name = registration.user.name
company = registration.user.company


if (registration.ticket_type == 'organizer' || registration.ticket_type == 'volunteer') and company.downcase == 'cisco'
  p_pdf.text 'Filmcrew',
      :at => [169,0],
      :size => 36

elsif registration.ticket_type == 'organizer'
  p_pdf.text 'Arrangør',
      :at => [170,0],
      :size => 36


elsif registration.ticket_type == 'volunteer'
  p_pdf.text 'Frivillig',
      :at => [183,0],
      :size => 36
end

p_pdf.fill_color 'aa0000'
p_pdf.cell [0,380],
    :font_size => 48,
    :text => name,
    :width => 257,
    :padding => 0,
    :border_width => 50,
    :border_style => :no_bottom,
    :border_color => 'aa0000',
    :background_color => 'aa0000'


p_pdf.fill_color 'ffffff'
p_pdf.cell [-20,373],
    :font_size => 48,
    :text => name,
    :width => 297,
    :padding => 20,
    :border_width => 0

p_pdf.fill_color '000000'

p_pdf.move_up 12

p_pdf.text company,
    :size => 20




