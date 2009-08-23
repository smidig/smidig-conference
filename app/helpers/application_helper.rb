
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_id
    controller.controller_name == 'pages' ? controller.action_name : controller.controller_name
  end

  def controller_is?(matching_controllers)
    matching_controllers = [matching_controllers] if matching_controllers.is_a? String
    matching_controllers.include? controller.controller_name
  end
  
  def page_menu_item(text, action)
    menu_class = current_page?(:controller => 'pages', :action => action) ? "menu_current" : "menu_link"
    %Q{<li id="#{action}_menu" class="#{menu_class} #{action}" title="#{text}">
      <span>#{ link_to_unless_current text, :controller => 'pages', :action => action }</span></li>}
  end
  
  def program_menu_item
    menu_class = controller_is?(%w(talks topics)) ? "menu_current" : "menu_link"
    %Q(<li id="program_menu" class="#{menu_class} topics" title="Program"
      ><span>#{ link_to_unless_current "Program", topics_path }</span></li>)
  end

  def user_menu_item
    menu_class = controller_is?(%w(users)) ? "menu_current" : "menu_link"
    text = current_user ? "Min påmelding" : "Meld meg på!"
    path = current_user ? current_users_path : new_user_path
    %Q(<li id="users_menu" class="#{menu_class} users">
        <span>#{link_to_unless_current text, path }</span>
      </li>)
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
