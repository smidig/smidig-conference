
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_menu_item(text, action)
    if current_page?(:controller => 'pages', :action => action)
      %Q{<li id="#{action}_menu" class="menu_current" title="#{text}">#{text}</li>}
    else
      %Q{<li id="#{action}_menu" class="menu_link" title="#{text}">#{ link_to text, :controller => 'pages', :action => action }</li>}
    end
  end

  def menu_item(text, id, route)
    if current_page?(route)
      %Q{<li id="#{id}_menu" class="menu_current" title="#{text}">#{text}</li>}
    else
      %Q{<li id="#{id}_menu" class="menu_link" title="#{text}">#{ link_to text, route }</li>}
    end
  end

  def feed_link(title, url)
    feed_icon_tag(title, url) + " " + link_to(title, url)
  end

  def feed_icon_tag(title, url)
    (@feed_icons ||= []) << { :url => url, :title => title }
    link_to image_tag('icon_feed.png', :size => '14x14', :alt => "Subscribe to #{title}"), url
  end
  
  def logged_in
    current_user
  end
  
  # Don't include the following in production or staging
  def unfinished
    yield unless (RAILS_ENV == 'production' || RAILS_ENV == 'staging')
  end
end
