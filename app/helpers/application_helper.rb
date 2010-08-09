
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_id
    controller.controller_name == 'info' ? controller.action_name : controller.controller_name
  end

  def controller_is?(matching_controllers)
    matching_controllers = [matching_controllers] if matching_controllers.is_a? String
    matching_controllers.include? controller.controller_name
  end

  def info_menu_item(text, action)
    active = current_page?(:controller => 'info', :action => action)
    %Q{<li id="#{action}_menu" class="#{menu_class(active)} #{action}" title="#{text}">
      #{ link_to_unless_current text, :controller => 'info', :action => action }</li>}
  end

  def menu_class(active)
    active ? "active" : "inactive"
  end

  def program_menu_item
    active = controller_is?(%w(talks topics periods program))
    %Q(<li id="program_menu" class="#{menu_class(active)} topics" title="Program"
      >#{ link_to_unless_current "Program", :controller => 'program', :action => 'index' }</li>)
  end

  def user_menu_item
    active = controller_is?(%w(users))
    text = current_user ? "min påmelding" : "meld deg på!"
    path = current_user ? current_users_path : signup_path
    %Q(<li id="users_menu" class="#{menu_class(active)} users">
       #{link_to_unless_current text, path }
      </li>)
  end

  def talk_menu_item(label)
    active = controller_is?(%w(talks))
    %Q(<li id="talks_menu" class="#{menu_class(active)} talks">
       #{ link_to_unless_current "lyntaler", :controller => 'talks', :action => 'index' }
      </li>)
  end

  def login_menu_item
    text = current_user ? "logg ut" : "logg inn"
    path = current_user ? logout_path : login_path
    active = current_page?(path)
    %Q(<li id="login_menu" class="#{menu_class(active)} login">
       #{link_to_unless_current text, path }
      </li>)
  end

  def feed_link(title, url)
    %Q(<span class="feed" title="#{title}">
       #{feed_icon_tag(title, url)}
      </span>)


  end

  def feed_icon_tag(title, url)
    (@feed_icons ||= []) << { :url => url, :title => title }
    link_to image_tag('icon_feed.png', :size => '14x14', :alt => "Subscribe to #{title}"), url
  end

  def floating_text_box(text)
	%Q{	<p class="quote">#{text}</p> }
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
