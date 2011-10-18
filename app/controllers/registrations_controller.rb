# -*- encoding : utf-8 -*-

class RegistrationsController < ApplicationController
  before_filter :require_user
  before_filter :require_admin_or_owner, :except => [:index]
  before_filter :require_admin, :only => [:index, :delete, :confirm_delete, :phone_list]

  def index
    @conditions = params[:conditions] || {}
    @registrations = Registration.find_by_params(params)
    @ticket_types = @registrations.collect { |r| r.ticket_type }.uniq

    first_registration = @registrations.min {|x,y| x.created_at.to_date <=> y.created_at.to_date}
    @date_range = first_registration ? (first_registration.created_at.to_date-1..Date.today).to_a : []
    @all_per_date = total_by_date(@registrations, @date_range)
    @registrations_per_ticket_type_per_date = per_ticket_type_by_date(@registrations, @date_range)
    @paid_per_date = total_by_date(@registrations, @date_range)

    @income_per_date = total_price_per_date(@registrations, @date_range)
  end
  
  def invoiced
    @registrations = Registration.paying
  end
  
  def speakers
    @registrations = Registration.speakers
    @talks = Talk.all
  end

  def phone_list
    @registrations = Registration.find_by_params(params)
    @ticket_types = @registrations.collect { |r| r.ticket_type }.uniq

    first_registration = @registrations.min {|x,y| x.created_at.to_date <=> y.created_at.to_date}
    @date_range = (first_registration.created_at.to_date-1..Date.today).to_a
    @all_per_date = total_by_date(@registrations, @date_range)
    @registrations_per_ticket_type_per_date = per_ticket_type_by_date(@registrations, @date_range)
    @paid_per_date = total_by_date(@registrations, @date_range)

    @income_per_date = total_price_per_date(@registrations, @date_range)
  end


  def edit
    @registration = Registration.find(params[:id])
    @registration.payment_notification ||= PaymentNotification.new
  end

  # PUT /registrations/1
  # PUT /registrations/1.xml
  def update
    @registration = Registration.find(params[:id])
    if admin?
      if params[:ticket_change]
        @registration.ticket_type = params[:registration][:ticket_type]
        @registration.includes_dinner = params[:registration][:includes_dinner]
        @registration.create_payment_info
      else
        @registration.completed_by = current_user.email if admin? and @registration.registration_complete
        @registration.registration_complete = params[:registration][:registration_complete]
        @registration.payment_reference = params[:registration][:payment_reference]
        @registration.paid_amount = params[:registration][:paid_amount]
        @registration.invoiced = params[:registration][:invoiced]
        @registration.user.is_admin =
          (@registration.ticket_type == "organizer" && @registration.registration_complete)
        @registration.user.save!
      end
    end

    if @registration.update_attributes(params[:registration])
      flash[:notice] = "Informasjonen er oppdatert#{' - husk å sende mail til bruker' if admin?}"
      redirect_to @registration.user
    else
      flash.now[:error] = 'Kunne ikke oppdatere informasjonen'
      render :action => "edit"
    end
  end

  def delete
    @registration = Registration.find(params[:id])

    if params[:name][0..2].downcase == params[:confirmation][0..2].downcase
      @registration.user.talks.delete
      @registration.user.delete
      @registration.delete

      flash[:notice] = "Slettet bruker #{@registration.user.name}"
      redirect_to :action => 'index'
    else
      flash[:error] = "Feil bokstaver - prøv igjen"
      render :action => "confirm_delete"
    end
  end

  def confirm_delete
    @registration = Registration.find(params[:id])
  end

  # GET /registrations/:id/receipt
  def receipt
    @r = Registration.find(params[:id])
    @u = @r.user
    if @r.registration_complete?
      render :layout => false
    else
      flash[:error] = "Kan ikke vise kvittering - Du har ikke betalt"
      redirect_back_or_default root_url
    end
  end

protected
  def require_admin_or_owner
    if !current_user
      store_location
      flash[:notice] = "Du må være logget inn for å se siden."
      redirect_to new_user_session_url
      return false
    end
    @registration = Registration.find(params[:id]) unless params[:id].blank?
    if (@registration && @registration.user == current_user) || personal_admin?
      return true
    elsif admin?
      store_location
      flash[:notice] = "Du må være administrator registrert med personlig email for å se siden."
      redirect_to new_user_session_url
      return false
    else
      flash[:notice] = "Du har ikke lov å se siden"
      redirect_to root_url
      return false
    end
  end

  def require_personal_admin
    unless personal_admin?
      store_location
      flash[:notice] = "Du må være administrator registrert med personlig email for å se siden."
      redirect_to new_user_session_url
      return false
    end
  end

  def per_ticket_type_by_date(registrations, date_range)
    registrations_by_ticket_type = registrations.group_by { |u| u.ticket_type }
    result = {}
    for ticket_type in registrations_by_ticket_type.keys
      result[ticket_type] = total_by_date(registrations_by_ticket_type[ticket_type], date_range)
    end
    result
  end

  def total_by_date(registrations, date_range)
    registrations_by_date = registrations.group_by { |u| u.created_at.to_date }
    per_date = []
    total = 0
    for day in date_range do
      total += registrations_by_date[day].size if registrations_by_date[day]
      per_date << total
    end
    per_date
  end

  def total_price_per_date(registrations, date_range)
    registrations_by_date = registrations.group_by { |u| u.created_at.to_date }
    per_date = []
    total = 0
    for day in date_range do
      for reg in registrations_by_date[day] || []
        total += reg.paid_amount.to_i || 0
      end
      per_date << total
    end
    per_date
  end

end
