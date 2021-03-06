# -*- encoding : utf-8 -*-
class WorkshopParticipantController < ApplicationController
  before_filter :require_user
  before_filter :load_talk

  # GET /workshop_participants
  # GET /workshop_participants.xml
  def index
    if @talk.user_ids.include?(current_user.id) || current_user.is_admin?
      @participants = @talk.workshop_participants.collect {|p| p.user }
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @participants }
      end
    else
      flash[:error] = "Access Denied"
      redirect_to new_user_path
    end
  end

  # POST /workshop_participants
  # POST /workshop_participants.xml
  def create
    @wsp = WorkshopParticipant.new(:user => current_user, :talk => @talk)

    respond_to do |format|
      if @talk.complete?
        flash[:error] = "Workshoppen er full"
        format.html { redirect_to(@talk) }
        format.xml { render :xml => @wsp, :status => :unprocessable_entity }
      elsif @wsp.save
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

    if @wsp.user_id == current_user.id || current_user.is_admin?
      if @wsp.destroy
        flash[:notice] = "Du er ikke med lengre i workshoppen"
      end
      respond_to do |format|
        format.html { redirect_to(@talk) }
        format.xml  { head :ok }
      end
    else
      flash[:error] = "Access Denied"
      redirect_to new_user_path
    end
  end

  protected
  def load_talk
    @talk = Talk.workshops.joins(:speakers).find(params[:talk_id])
  end
end
