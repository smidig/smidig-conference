class AcceptancesController < ApplicationController

  before_filter :require_admin

  def index
    @talks = Talk.all_with_speakers

    num_accepted = Talk.count(:conditions => "acceptance_status = 'accepted'")
    num_refused = Talk.count(:conditions => "acceptance_status = 'refused'")
    num_pending = Talk.count(:conditions => "acceptance_status = 'pending'")
    @types = {:accepted => num_accepted,
              :refused => num_refused,
              :pending => num_pending
    }
  end

  def accept
    @talk = Talk.find(params[:id], :include => [{:users => :registration}])

    if(@talk.email_is_sent?)
      flash[:error] = "Kan ikke endre status på foredrag '#{@talk.title}', mail allerede sendt ut."
      redirect_to :controller => :acceptances
    end

    @talk.acceptance_status = "accepted"
    @talk.save

    for speaker in @talk.users
      unless speaker.registration.special_ticket?
        speaker.registration.registration_complete = true
        speaker.registration.completed_by = current_user.email if admin?
        speaker.registration.save
      end
    end

    flash[:notice] = "#{@talk.speaker_name}s foredrag '#{@talk.title}' godkjent."
    redirect_to :controller => :acceptances
  end

  def refuse
    @talk = Talk.find(params[:id])

    if(@talk.email_is_sent?)
      flash[:error] = "Kan ikke endre status på foredrag '#{@talk.title}', mail allerede sendt ut."
      redirect_to :controller => :acceptances
    end

    @talk.acceptance_status = "refused"
    @talk.save

    for speaker in @talk.users
      if (speaker.all_talks_refused? && !speaker.registration.special_ticket?)
        speaker.update_to_paying_user
        speaker.registration.save
      end
    end

    flash[:notice] = "#{@talk.speaker_name}s foredrag '#{@talk.title}' refusert."
    redirect_to :controller => :acceptances
  end

  def await
    @talk = Talk.find(params[:id])

    if(@talk.email_is_sent?)
      flash[:error] = "Kan ikke endre status på foredrag '#{@talk.title}', mail allerede sendt ut."
      redirect_to :controller => :acceptances
    end

    @talk.acceptance_status = "pending"
    @talk.save

    for speaker in @talk.users
      unless speaker.registration.special_ticket?
        speaker.registration.ticket_type = "speaker"
        speaker.registration.registration_complete = false
        speaker.registration.completed_by = ""
        speaker.registration.save
      end
    end

    flash[:notice] = "#{@talk.speaker_name}s foredrag '#{@talk.title}' avventet."
    redirect_to :controller => :acceptances
  end

  def send_mail
    @talk = Talk.find(params[:id])

    if @talk.email_sent
      flash[:error] = "Kan ikke sende mail for foredrag '#{@talk.title}': Mail allerede sendt!"
      redirect_to :controller => :acceptances
      return
    end

    if @talk.acceptance_status == 'refused'
      SmidigMailer.deliver_talk_refusation_confirmation(@talk)
      @talk.email_sent = true
    elsif @talk.acceptance_status == 'accepted'
      SmidigMailer.deliver_talk_acceptance_confirmation(@talk)
      @talk.email_sent = true
    else
      flash[:error] = "Kan ikke sende mail for foredrag '#{@talk.title}': Foredraget er ikke akseptert/refusert enda!"
      redirect_to :controller => :acceptances
      return
    end

    @talk.save
    flash[:notice] = "Sendt mail om '#{@talk.title}'"
    redirect_to :controller => :acceptances
  end

end