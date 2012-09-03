# -*- encoding : utf-8 -*-
class PaymentNotificationsController < ApplicationController
  #protect_from_forgery :except => [:create]
  def create
    registration = Registration.find_by_invoice(params[:invoice])
    registration.payment_notification_params = params
    registration.paid_amount = params[:mc_gross].to_i
    registration.payment_reference = params[:txn_id]
    registration.payment_complete_at = Time.now
    registration.registration_complete = (registration.paid_amount == registration.price)
    registration.save!
    
    PaymentNotification.create!(:params => params, :registration => registration, :status => params[:payment_status], :transaction_id => params[:txn_id], :paid_amount => params[:mc_gross], :currency => params[:mc_currency])
    
    SmidigMailer.payment_confirmation(registration).deliver
    
    render :nothing => true
  end
  
  def index
    #registration = Registration.find_by_invoice(params[:invoice])

    @payment_notifications = PaymentNotification.find(:all)
    logger.info 'Using get..'
    render :xml => @payment_notifications
#
#    respond_to do |format|
#      #format.html # index.html.erb
#      format.xml  { render :xml => @payment_notifications }
#    end
  end
  def new
    @payment_notification = PaymentNotification.new

    render :xml => @payment_notification
    #respond_to do |format|
      #format.html # new.html.erb
    #  format.xml  { render :xml => @payment_notification }
    #end
  end
  
end
