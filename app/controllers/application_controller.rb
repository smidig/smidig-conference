# encoding: UTF-8

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '94cfd79349d51c387abaa8e52ad96b1f' 

  filter_parameter_logging :password, :password_confirmation

  helper_method :current_user_session, :current_user, :access_denied

  private
  
  def admin?
    current_user and current_user.is_admin
  end
  
  def personal_admin?
    admin? and current_user.email != "admin@smidig.no"
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "Du må logge inn for å se siden."
      redirect_to new_user_session_url
      return false
    end
  end

  def require_admin
    unless admin?
      store_location
      flash[:notice] = "Du må være administrator for å se siden."
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "Du må logge ut for å se siden."
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
  
  def store_referer
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def access_denied
    respond_to do |format|
      format.html do
        if current_user
          redirect_to root_path
        else
          redirect_to new_user_session_path
        end
      end
      format.any(:json, :xml) do
        request_http_basic_authentication 'Web Password'
      end
    end
  end

end
