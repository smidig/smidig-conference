# -*- encoding : utf-8 -*-
class WorkshopParticipantController < ApplicationController
  before_filter :require_user
  before_filter :load_talk

  # GET /workshop_participants
  # GET /workshop_participants.xml
  def index
    # TODO owner check
    # ... current_user.is_admin? or  @talk.speaker_ids.includes?(current_user.id)
    @participants = @talk.workshop_participants
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @participants }
    end
  end
  
  # POST /workshop_participants
  # POST /workshop_participants.xml
  def create
    # TODO if full check
    @wsp = WorkshopParticipant.new(:user => current_user, :talk => @talk)

    respond_to do |format|
      if @wsp.save
        flash[:notice] = "Du er med i workshoppen"
        format.html { redirect_to(@talk) }
        format.xml { render :xml => @wsp }
      else
        flash[:error] = "Du er ikke med i workshoppen"
        format.html { redirect_to(@talk) }
        format.xml { render :xml => @wsp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /workshop_participants
  # DELETE /workshop_participants.xml
  def destroy
    @wsp = WorkshopParticipant.find(params[:id])
    # TODO current user check
    # unless current_user.is_admin? or @wsp.user_id == current_user.id
    #    -> no way, punk
    if @wsp.destroy
      flash[:notice] = "Du er ikke med lengre i workshoppen"
    end
    respond_to do |format|
      format.html { redirect_to(@talk) }
      format.xml  { head :ok }
    end
  end

  protected
  def load_talk
    @talk = Talk.workshops.find(params[:talk_id])
    # TODO what about not acceptance_status?
  end
end
