class UsersController < ApplicationController
  before_filter :require_admin, :only => [ :index, :show ]  
  
  def index
    @users = User.find(:all, :include => :registration)
  end
  
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def new
    @user = User.new
    @user.registration = Registration.new
  end

  def create
    @user = User.new(params[:user])
    @registration = Registration.new
    @registration.user = @user
          
    if @user.save
      
      # find price based on options
  
      @registration.is_earlybird = true
  
      if params["ticket_type"] == "uten_middag"
        @registration.includes_dinner = false
        @registration.price = 1000
        @registration.description = "Earlybird-billett til Smidig 2009 uten middag"
      else
        @registration.includes_dinner = true
        @registration.price = 1500
        @registration.description = "Earlybird-billett til Smidig 2009 inkludert middag"
      end
        
      @user_session = UserSession.new
      @user_session.email = @user.email
      @user_session.password = @user.password      
      
      @registration.save
      
      values = {
        :business => 'experi_1243951372_biz@iterate.no',
        :cmd => '_cart',
        :upload => '1',
        :currency_code => 'NOK',
        :notify_url => 'http://experimental.smidig2009.no/payment_notifications',
        :return => 'http://experimental.smidig2009.no/users/current/edit',
        :invoice => @registration.id,
        :amount_1 => @registration.price,
        :item_name_1 => @registration.description,
        :item_number_1 => '1',
        :quantity_1 => '1'
      }
      
      @registration.payment_link = "https://www.sandbox.paypal.com/cgi-bin/websrc?"+values.map {|k,v| "#{k}=#{v}" }.join("&")
    
      @registration.save
      @user_session.save
    
      redirect_to @registration.payment_link
     
     else
       render :action => 'new'
     end
  end
  
  def edit
    @user = current_user
    @paid = false
    @paid_amount = 0
    @payment_notification = nil
    if @user.registration != nil && @user.registration.payment_notification != nil
      @payment_notification = @user.registration.payment_notification
       if @user.registration.payment_notification.status =="Completed"
         @paid_amount = @user.registration.price
         @paid = true
      end
    end
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated profile."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
end
