
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_menu_item(text, action)
    if current_page?(:controller => 'pages', :action => action)
      %Q{<li id="#{action}_menu" class="menu_current #{action}" title="#{text}"><span>#{text}</span></li>}
    else
      %Q{<li id="#{action}_menu" class="menu_link #{action}" title="#{text}"><span>#{ link_to text, :controller => 'pages', :action => action }</span></li>}
    end
  end

  def menu_item(text, id, route)
    if current_page?(route)
      %Q{<li id="#{id}_menu" class="menu_current #{route[:controller]}" title="#{text}"><span>#{text}</span></li>}
    else
      %Q{<li id="#{id}_menu" class="menu_link #{route[:controller]}" title="#{text}"><span>#{ link_to text, route }</span></li>}
    end
  end

  def feed_link(title, url)
    feed_icon_tag(title, url) + " " + link_to(title, url)
  end

  def feed_icon_tag(title, url)
    (@feed_icons ||= []) << { :url => url, :title => title }
    link_to image_tag('icon_feed.png', :size => '14x14', :alt => "Subscribe to #{title}"), url
  end
  
  def floating_text_box(text)
	%Q{
		<div class='floating_text_box note'>
		  <div class='content'>
		    <div class='top'></div>
		    <div class='background-color'>
		    #{text}
		    </div>
		  </div>
		  <div class='bottom'>
		    <div></div>
		  </div>
		</div>
	}
  end
  
  
  def logged_in
    current_user
  end
  
  def admin?
    current_user and current_user.is_admin
  end
  
  # Don't include the following in production or staging
  def unfinished
    yield unless (RAILS_ENV == 'production' || RAILS_ENV == 'staging')
  end
end
