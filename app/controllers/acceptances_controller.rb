# -*- encoding : utf-8 -*-

class AcceptancesController < ApplicationController

  before_filter :require_admin

  def index
    @talks = Talk.all_with_speakers

    num_accepted = Talk.count_accepted
    num_refused = Talk.count_refused
    num_pending = Talk.count_pending
    @types = {:accepted => num_accepted,
              :refused => num_refused,
              :pending => num_pending
    }
  end

  def accept
    @talk = Talk.find(params[:id], :include => [{:users => :registration}])

    return if email_already_sent?

    @talk.accept!
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
    return if email_already_sent?

    @talk.refuse!
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

    return if email_already_sent?

    @talk.regret! #Set to pending :)
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

    return if email_already_sent?

    if @talk.refused?
      SmidigMailer.talk_refusation_confirmation(@talk).deliver
      @talk.email_sent = true
    elsif @talk.accepted?
      SmidigMailer.talk_acceptance_confirmation(@talk).deliver
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


  protected
  def email_already_sent?
    if @talk.email_is_sent?
      msg = "Kan ikke endre status på foredrag '#{@talk.title}', mail allerede sendt ut."
      flash[:error] = msg
      logger.warn(msg)
      redirect_to :controller => :acceptances
    end
  end

end
