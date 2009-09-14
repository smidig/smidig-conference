class RegistrationsController < ApplicationController
  before_filter :require_personal_admin
  
  
  def edit
  	@registration = Registration.find(params[:id])
  	@registration.payment_notification ||= PaymentNotification.new
  end

  # PUT /registrations/1
  # PUT /registrations/1.xml
  def update
    @registration = Registration.find(params[:id])
  	@registration.payment_notification ||= PaymentNotification.new
  	@registration.payment_notification.registered_by = current_user.email
  	@registration.payment_notification.status = "Completed"
    
    if @registration.payment_notification.update_attributes(params[:registration][:payment_notification])
      flash[:notice] = 'Informasjonen er oppdatert - husk å sende mail til bruker'
	    redirect_to @registration.user
	  else
      flash.now[:error] = 'Alle felter må fylles ut'
      render :action => "edit"
	  end
  end

protected
  def require_personal_admin
    unless current_user && current_user.is_admin && current_user.email != "admin@smidig.no"
      store_location
      flash[:notice] = "Du må være administrator registrert med personlig email for å se siden."
      redirect_to new_user_session_url
      return false
    end
  end

end
