require 'prawn/layout'
require 'prawn/format'


p_pdf.font_families.update(
    "League Gothic" => { :normal => "#{Rails.root}/public/stylesheets/League_Gothic-webfont.ttf" },
    "Blackout" => { :normal => "#{Rails.root}/public/stylesheets/Blackout-Midnight-webfont.ttf" }
)

p_pdf.font 'Blackout'
p_pdf.fill_color 'f0f0f0'
p_pdf.text '2012',
    :at => [20,-10],
    :overflow => :truncate,
    :size => 160

p_pdf.font 'League Gothic'
p_pdf.fill_color '110039'

name = registration.user.name
company = registration.user.company


if (registration.ticket_type == 'organizer' || registration.ticket_type == 'volunteer') and company.downcase == 'cisco'
  p_pdf.text 'Filmcrew',
      :at => [189,20],
      :size => 36
elsif registration.ticket_type == 'organizer'
  p_pdf.text 'Arrangør',
      :at => [190,20],
      :size => 36
elsif registration.ticket_type == 'volunteer'
  p_pdf.text 'Frivillig',
      :at => [203,20],
      :size => 36
elsif registration.ticket_type == 'guest'
  p_pdf.fill_color '0000cc'
  p_pdf.text 'Begrenset tilgang',
      :at => [100,20],
      :size => 36
end

p_pdf.fill_color 'B1E038'
p_pdf.table [[name]],
    :font_size  => 48,
    :horizontal_padding => 20,
    :vertical_padding => 50,
    :width => 297,
    :border_width => 0,
    :position => :left,
    :row_colors  => ['110039']



p_pdf.move_up 30
p_pdf.fill_color '000000'
p_pdf.table [[company]],
    :font_size  => 20,
    :horizontal_padding => 20,
    :width => 297,
    :border_width => 0,
    :position => :left,
    :row_colors  => ['ffffff']
