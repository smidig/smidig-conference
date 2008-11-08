class MessageDeliveriesController < ApplicationController
  # GET /message_deliveries
  # GET /message_deliveries.xml
  def index
    @message_deliveries = MessageDelivery.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @message_deliveries }
    end
  end

  # GET /message_deliveries/1
  # GET /message_deliveries/1.xml
  def show
    @message_delivery = MessageDelivery.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message_delivery }
    end
  end

  # GET /message_deliveries/new
  # GET /message_deliveries/new.xml
  def new
    @message_delivery = MessageDelivery.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message_delivery }
    end
  end

  # GET /message_deliveries/1/edit
  def edit
    @message_delivery = MessageDelivery.find(params[:id])
  end

  # POST /message_deliveries
  # POST /message_deliveries.xml
  def create
    @message_delivery = MessageDelivery.new(params[:message_delivery])

    respond_to do |format|
      if @message_delivery.save
        flash[:notice] = 'MessageDelivery was successfully created.'
        format.html { redirect_to(@message_delivery) }
        format.xml  { render :xml => @message_delivery, :status => :created, :location => @message_delivery }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message_delivery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /message_deliveries/1
  # PUT /message_deliveries/1.xml
  def update
    @message_delivery = MessageDelivery.find(params[:id])

    respond_to do |format|
      if @message_delivery.update_attributes(params[:message_delivery])
        flash[:notice] = 'MessageDelivery was successfully updated.'
        format.html { redirect_to(@message_delivery) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message_delivery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /message_deliveries/1
  # DELETE /message_deliveries/1.xml
  def destroy
    @message_delivery = MessageDelivery.find(params[:id])
    @message_delivery.destroy

    respond_to do |format|
      format.html { redirect_to(message_deliveries_url) }
      format.xml  { head :ok }
    end
  end
end
