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

end