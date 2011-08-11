# -*- encoding : utf-8 -*-

class PasswordResetsController < ApplicationController
  
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  
  def new
    @email = params[:email]
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.password_reset_instructions!.deliver
      flash[:notice] = "Vi har sendt instruksjoner for å endre passord til den angitte emailadressen. Følg instruksjonene for å endre passordet."
      redirect_to root_url
    else
      flash[:error] = "Det finnes ingen bruker med den adressen"
      render :action => :new
    end
  end
  
  def edit
  end
  
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Ditt passord har blitt oppdatert"
      redirect_to user_url(@user)
    else
      render :action => :edit
    end
  end
  
private

  def load_user_using_perishable_token
    @user = User.find_by_perishable_token(params[:id])
    if not @user
      flash[:notice] = "Vi beklager, men vi kunne ikke finne din konto. " +
        "Vennligst dobbeltsjekk at du har brukt korrekt link i mailen du har mottatt"
      redirect_to root_url
    end
  end
  
  
    
end
