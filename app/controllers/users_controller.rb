class UsersController < ApplicationController
  before_filter :require_user, :except => [ :new, :create ]
  before_filter :require_admin, :only => [ :index ]
  before_filter :require_admin_or_self, :only => [ :show, :edit, :update ]

  def index
    redirect_to registrations_path
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
    if current_user
      redirect_to current_users_url
      return
    end

    @user = User.new
    @user.registration = Registration.new
    @user.registration.manual_payment = params[:manual_payment]
    @user.registration.free_ticket = !params[:free_ticket].blank?
    @user.registration.ticket_type = params[:free_ticket] || params[:ticket_type] || 'full_price'
	@user.registration.includes_dinner = @user.registration.discounted_ticket?
  end

  def create
    if current_user
      redirect_to current_users_url
      return
    end



    User.transaction do
      @user = User.new(params[:user])
      @user.email.strip! if @user.email.present?
      @user.registration_ip = request.remote_ip  #Store the ip address used at registration time, to send mails later (ask jhannes)

      if User.count >= 500
        flash[:error] = "Vi har nådd maksgrensen for påmeldinger, vennligst send oss mail på kontakt@smidig.no så ser vi hva vi får gjort"
        logger.error("Hard limit for number of users (500) has been reached. Please take action.")
        SmidigMailer.deliver_error_mail("Error on smidig2010.no", "Hard limit for number of users (500) has been reached. Please take action.")
        render :action => 'new'
      elsif @user.valid?
        @user.registration.ticket_type = "speaker" if params[:speaker]
        @user.save
        if !@user.registration.save
          raise @user.registration.errors.inspect
        end
        UserSession.login(@user.email, @user.password)
        if @user.registration.manual_payment
          flash[:notice] = "Vi vil kontakte deg for å bekrefte detaljene"
          SmidigMailer.deliver_manual_registration_confirmation(@user)
          SmidigMailer.deliver_manual_registration_notification(@user, user_url(@user))
          redirect_to @user
        elsif @user.registration.speaker?
          flash[:notice] = "Registrer detaljene for din lyntale"
          SmidigMailer.deliver_speaker_registration_confirmation(@user)
          SmidigMailer.deliver_speaker_registration_notification(@user, user_url(@user))
          redirect_to new_talk_url
        elsif @user.registration.free_ticket
          flash[:notice] = "Vi vil kontakte deg for å bekrefte detaljene"
          SmidigMailer.deliver_free_registration_confirmation(@user)
          SmidigMailer.deliver_free_registration_notification(@user, user_url(@user))
          redirect_to @user
        else
          SmidigMailer.deliver_registration_confirmation(@user)
          redirect_to @user.registration.payment_url(payment_notifications_url, user_url(@user))
        end
      else
        flash[:error] = "En feil har oppstått, se veiledningen under."
        render :action => 'new'
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    update_user
  end

  def chat
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

  def total_by_date(users, date_range)
    users_by_date = users.group_by { |u| u.created_at.to_date }
    per_date = []
    total = 0
    for day in date_range do
      total += users_by_date[day].size if users_by_date[day]
      per_date << total
    end
    per_date
  end

  def total_price_per_date(users, date_range)
    users_by_date = users.group_by { |u| u.created_at.to_date }
    per_date = []
    total = 0
    for day in date_range do
      for user in users_by_date[day] || []
        total += user.registration.price || 0 if user.registration && user.registration.paid?
      end
      per_date << total
    end
    per_date
  end

end
