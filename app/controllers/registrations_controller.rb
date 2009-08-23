class RegistrationsController < ApplicationController
  before_filter :require_admin

  # PUT /registrations/1
  # PUT /registrations/1.xml
  def update
    @registration = Registration.find(params[:id])
    
    SmidigMailer.deliver_payment_confirmation(@registration)
    
    flash[:notice] = 'Har sent email til bruker'
    redirect_to @registration.user
  end

end
