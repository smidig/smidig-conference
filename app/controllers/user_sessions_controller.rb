# -*- encoding : utf-8 -*-
class UserSessionsController < ApplicationController
  before_filter :require_user, :only => [:restricted, :destroy, :logout]

  def new
    store_referer if params[:save]
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Velkommen tilbake!"
      redirect_back_or_default root_url
    else
      flash[:error] = "Feil brukernavn eller passord"
      redirect_to :action => 'new'
    end
  end

  def logout
    @user_session = UserSession.find
    @user_session.destroy
    redirect_to '/'
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Logget ut."
    redirect_to '/'
  end

  def restricted
    render :text => "OK"
  end
end
