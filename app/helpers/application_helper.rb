# -*- encoding : utf-8 -*-

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
      #{ link_to_unless_current text, :controller => 'info', :action => action }</li>}.html_safe
  end

  def menu_class(active)
    active ? "active" : "inactive"
  end

  def program_menu_item(label = 'Program')
    active = controller_is?(%w(talks topics periods program))
    %Q(<li id="program_menu" class="#{menu_class(active)} topics" title="#{label}"
      >#{ link_to_unless_current label, :controller => 'program', :action => 'index' }</li>).html_safe
  end

  def user_menu_item
    current_user ? user_menu_item_current : user_menu_item_new
  end

  def user_menu_item_new
    active = controller_is?(%w(users))

    menu_items = ""
    [ {:key => 'login', :text => "logg inn",     :path => login_path},
      {:key => 'users', :text => "meld deg på!", :path => new_user_path}].each do |m|
      menu_items += %Q(<li class="#{menu_class(active)} #{m[:key]}">
       #{link_to(m[:text], m[:path]) }
       </li>)
    end
   menu_items.html_safe
  end


  def user_menu_item_current
    active = controller_is?(%w(users))
    text =  "min påmelding"
    path = current_users_path
    %Q(<li class="#{menu_class(active)} users">
       #{active ? text : link_to(text, path) }
      </li>).html_safe
  end

  def talk_menu_item(label)
    active = controller_is?(%w(talks))
    %Q(<li id="talks_menu" class="#{menu_class(active)} talks">
       #{ link_to_unless_current "bidrag", :controller => 'talks', :action => 'index' }
      </li>).html_safe
  end

  def login_menu_item
    text = current_user ? "logg ut" : "logg inn"
    path = current_user ? logout_path : login_path
    active = current_page?(path)
    %Q(<li id="login_menu" class="#{menu_class(active)} login">
       #{link_to_unless_current text, path }
      </li>).html_safe
  end

  def sponsor(name, logo, url)
    link_to image_tag( 'logos/' + logo, :alt => name), url, :tabindex =>  -1
  end

  def feed_link(title, url)
    %Q(<span class="feed" title="#{title}">
       #{feed_icon_tag(title, url)}
      </span>).html_safe
  end

  def feed_icon_tag(title, url)
    (@feed_icons ||= []) << { :url => url, :title => title }
    link_to image_tag('icon_feed.png', :size => '14x14', :alt => "Subscribe to #{title}"), url
  end

  def floating_text_box(text)
  %Q{  <p class="quote">#{text}</p> }.html_safe
  end

  def logged_in
    current_user
  end

  def admin?
    current_user and current_user.is_admin
  end

  # Don't include the following in production or staging
  def unfinished
    yield unless (Rails.env == 'production' || Rails.env == 'staging')
  end

  def mailingliste_url
    "http://groups.google.com/group/smidigkonferansen"
  end
  def twitter_url
    "http://twitter.com/smidig"
  end

  def help_tooltip(&block)
    ('<div class="tooltip"><img src="/images/help.png" alt="Mer informasjon" />' +
    '<div class="box help"><div class="inner"><div class="content">' +
    capture(&block) +
    '</div></div></div></div>').html_safe
  end

  def self.early_bird_end_date
    to_date "2011-09-16 23:59:59"
  end

  def self.to_date(a_string)
    DateTime.strptime(a_string, "%Y-%m-%d %H:%M:%S").to_time
  end


end
