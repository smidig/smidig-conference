# -*- encoding : utf-8 -*-
class InvoicesController < ApplicationController
  
  before_filter :require_user, :except => [ :new, :create ]
  before_filter :require_admin, :only => [ :index ]
  before_filter :require_admin_or_owner, :only => [ :show, :edit, :update ]

  def index
    @invoices = Invoice.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @invoice = Invoice.new
    @invoice.contact_user = User.new
    3.times { @invoice.registrations.build.user = User.new }

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @invoice = Invoice.find(params[:id])
  end

  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    params[:invoice][:existing_user_attributes] ||= {}
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      if @invoice.save
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(invoices_url) }
    end
  end
protected 

  def require_admin_or_owner
    invoice = Invoice.find(params[:id])
    unless current_user.is_admin? || invoice.contact_user == current_user
      flash[:error] = "Du må være administrator eller eier for å endre siden."
      access_denied
    end
  end

end
