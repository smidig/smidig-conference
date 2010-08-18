class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]
  def create
    PaymentNotification.create!(:params => params, :registration_id => params[:invoice], :status => params[:payment_status], :transaction_id => params[:txn_id], :paid_amount => params[:mc_gross], :currency => params[:mc_currency])
    
    registration = Registration.find_by_invoice(params[:invoice])
    registration.payment_notification_params = params
    registration.paid_amount = params[:mc_gross].to_i
    registration.payment_reference = params[:txn_id]
    registration.payment_complete_at = Time.now
    registration.registration_complete = (registration.paid_amount == registration.price)
    registration.save
    
    SmidigMailer.deliver_payment_confirmation(registration)
    
    render :nothing => true
  end
  
  def index
    @payment_notifications = PaymentNotification.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payment_notifications }
    end
  end
  def new
    @payment_notification = PaymentNotification.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @payment_notification }
    end
  end
  
end
