# -*- encoding : utf-8 -*-
class InvoicesController < ApplicationController
  
  before_filter :require_admin

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
    3.times { @invoice.users.build }

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
      @invoice.update_attributes(params[:invoice])
      for user in params[:deleted_users] || []
        @invoice.users.delete(@invoice.users.find(user.to_i))
      end
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
end