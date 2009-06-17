class UsersController < ApplicationController
  before_filter :require_user, :except => [ :new, :create ]
  before_filter :require_admin, :only => [ :index ]  
  before_filter :require_admin_or_self, :only => [ :show, :edit, :update ]  
  
  def index
    @users = User.find(:all, :include => :registration)
  end
  
  def current
    @user = current_user
    render "show"
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
    
    saved = false 
    User.transaction do
      if @user.save
        # find price based on options
    
        @registration.is_earlybird = true
    
        if params["ticket_type"] == "uten_middag"
          @registration.includes_dinner = false
          @registration.price = PRICE_CONFIG[:early_bird]
          @registration.description = "Earlybird-billett til Smidig 2009 uten middag"
        else
          @registration.includes_dinner = true
          @registration.price = PRICE_CONFIG[:early_bird_dinner]
          @registration.description = "Earlybird-billett til Smidig 2009 inkludert middag"
        end
          
        @user_session = UserSession.new
        @user_session.email = @user.email
        @user_session.password = @user.password      
        
        @registration.save
        
        values = {
          :business => PAYPAL_CONFIG[:paypal_email],
          :cmd => '_cart',
          :upload => '1',
          :currency_code => 'NOK',
          :notify_url => payment_notifications_url,
          :return => user_url(@user),
          :invoice => @registration.id,
          :amount_1 => @registration.price,
          :item_name_1 => @registration.description,
          :item_number_1 => '1',
          :quantity_1 => '1'
        }
        
        @registration.payment_link = PAYPAL_CONFIG[:paypal_url] +"?"+values.map do
          |k,v| "#{k}=#{CGI::escape(v.to_s)}"
        end.join("&")
      
        @registration.save
        @user_session.save
      
        saved = true
      end
    end

    if saved
      redirect_to @registration.payment_link     
    else
       render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    update_user
  end
  
protected
  
  def update_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Oppdaterte profil."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

  def require_admin_or_self
    user = User.find(params[:id])
    unless (current_user.is_admin? || user == current_user)
      flash[:error] = "Du har ikke lov å se andre brukeres informasjon."
      access_denied
    end
  end  

end
