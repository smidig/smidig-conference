# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def textile(text)
    RedCloth.new(html_escape(text)).to_html
  end

  def feed_link(title, url)
    feed_icon_tag(title, url) + " " + link_to(title, url)
  end

  def feed_icon_tag(title, url)
    (@feed_icons ||= []) << { :url => url, :title => title }
    link_to image_tag('icon_feed.png', :size => '14x14', :alt => "Subscribe to #{title}"), url
  end
  
  def logged_in
    !!session[:user_id]
  end
end
