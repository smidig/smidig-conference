class UserSessionsController < ApplicationController
  before_filter :require_user, :only => [:restricted, :destroy, :logout]

  def new
    store_referer if params[:save]
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Logget inn."
      redirect_back_or_default root_url
    else
      flash[:error] = "Login incorrect."
      redirect_to :action => 'new'
    end
  end
  
  def logout
    current_user_session.destroy
    redirect_to root_url
  end            
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Logget ut."    
    redirect_to root_url
  end
  
  def restricted
    render :text => "OK"
  end
end
