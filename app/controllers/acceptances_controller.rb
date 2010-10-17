class AcceptancesController < ApplicationController

  before_filter :require_admin

  def index
    @talks = Talk.all_with_speakers
  end

  def accept
    @talk = Talk.find(params[:id], :include => [{:users => :registration}])
    @talk.acceptance_status = "accepted"
    @talk.save

    for speaker in @talk.users
      speaker.registration.registration_complete = true
      speaker.registration.completed_by = current_user.email if admin?
      speaker.registration.save
    end

    flash[:notice] = "#{@talk.speaker_name}s foredrag '#{@talk.title}' godkjent."
    redirect_to :controller => :acceptances
  end

  def refuse
    @talk = Talk.find(params[:id])
    @talk.acceptance_status = "refused"
    @talk.save

    for speaker in @talk.users
      if speaker.all_talks_refused?
        speaker.update_to_paying_user
        speaker.registration.save
      end
    end

    flash[:notice] = "#{@talk.speaker_name}s foredrag '#{@talk.title}' refusert."
    redirect_to :controller => :acceptances
  end

end