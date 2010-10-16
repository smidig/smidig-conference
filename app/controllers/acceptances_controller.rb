class AcceptancesController < ApplicationController

  before_filter :require_admin

  def index
    @talks = Talk.all_with_speakers
  end

  def accept
    set_new_status_and_go_to_acceptances("accepted")
  end

  def refuse
    set_new_status_and_go_to_acceptances("refused")
  end

protected
  def set_new_status_and_go_to_acceptances(status)
    @talk = Talk.find(params[:id])
    @talk.acceptance_status = status

    @talk.save

    redirect_to :controller => :acceptances
  end


end