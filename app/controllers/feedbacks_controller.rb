# -*- encoding : utf-8 -*-
class FeedbacksController < ApplicationController
  # GET /feedbacks
  # GET /feedbacks.xml
  def index
    @feedbacks = Feedback.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @feedbacks }
    end
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.xml
  def show
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feedback }
    end
  end

  # GET /feedbacks/new
  def new
      @feedback = Feedback.new
      @feedback.day = params[:day]

      accepted_talks = Talk.all_accepted
      talks_for_day = accepted_talks.select{ |talk| talk.period.day == params[:day] }
      slots = Hash.new

      for talk in talks_for_day
        slot_id = String(talk.period.time_id) + "|" + String(talk.position)
        if !slots[slot_id]
          slots[slot_id] = Array.new
        end

        slots[slot_id][talk.period.scene_id] = talk
      end

      slots = slots.sort

      for slot in slots
        vote = @feedback.feedback_votes.build
        vote.alternatives = slot[1]
      end

#    @periods = Period.find(:all, :include => { :talks => :users })
#    @periods_by_time_and_scene = Hash.new
#    for p in @periods
#      @periods_by_time_and_scene[p.time_id] ||= Hash.new
#      @periods_by_time_and_scene[p.time_id][p.scene_id] = p
#    end
#
#    @time_ids = @periods.collect { |p| p.time_id }.sort.uniq
#
#    @edit = params[:edit] && admin?
#    @all_talks = Talk.all_pending_and_approved if @edit
    

    respond_to do |format|
      format.html # new.html.erb
    end
  
    # Autogenerert
    #@feedback = Feedback.new

    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.xml  { render :xml => @feedback }
    #end
  end

  # GET /feedbacks/1/edit
  def edit
    @feedback = Feedback.find(params[:id])
  end

  # POST /feedbacks
  # POST /feedbacks.xml
  def create
    @feedback = Feedback.new(params[:feedback])

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to(@feedback, :notice => 'Feedback was successfully created.') }
        format.xml  { render :xml => @feedback, :status => :created, :location => @feedback }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feedback.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1
  # PUT /feedbacks/1.xml
  def update
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        format.html { redirect_to(@feedback, :notice => 'Feedback was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feedback.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.xml
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to(feedbacks_url) }
      format.xml  { head :ok }
    end
  end
end
