# -*- encoding : utf-8 -*-
require 'ostruct'

class FeedbackVotesController < ApplicationController
  before_filter :require_admin, :only => [:index, :delete, :show, :new, :edit]

  # GET /feedback_votes
  # GET /feedback_votes.xml
  def index
    @talks_feedbacks = FeedbackVote.find(:all, :order => "talk_id").group_by { |vote| vote.talk }
    @talks_feedbacks_count = []
    @talks_feedbacks.each do |talk, feedbacks|
      sum =0.0;count=0.0;
      feedbacks.each do |f|
        sum += f.vote
        count += 1
      end
      data = OpenStruct.new({:talk => talk, :feedbacks => feedbacks, :avg => (sum/count), :count => count })
      @talks_feedbacks_count.push data 
    end

    @talks_feedbacks_count.sort! { |a,b| b.avg <=> a.avg }

    respond_to do |format|
      format.html {render :layout => "application"} # index.html.erb
      format.xml  { render :xml => @feedback_votes }
    end
  end

  # GET /feedback_votes/1
  # GET /feedback_votes/1.xml
  def show
    @feedback_vote = FeedbackVote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feedback_vote }
    end
  end

  # GET /feedback_votes/new
  # GET /feedback_votes/new.xml
  def new
    @feedback_vote = FeedbackVote.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feedback_vote }
    end
  end

  # GET /feedback_votes/1/edit
  def edit
    @feedback_vote = FeedbackVote.find(params[:id])
  end

  # POST /feedback_votes
  # POST /feedback_votes.xml
  def create
    @feedback_vote = FeedbackVote.new(params[:feedback_vote])

    respond_to do |format|
      if @feedback_vote.save
        format.json  { render :json => "{status: 'ok'}", :status => :created}
        format.html { redirect_to(@feedback_vote, :notice => 'FeedbackVote was successfully created.') }
        format.xml  { render :xml => @feedback_vote, :status => :created, :location => @feedback_vote }
      else
        format.json  { render :json => "{status: 'failed'}", :status => :unprocessable_entity}
        format.html { render :action => "new" }
        format.xml  { render :xml => @feedback_vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feedback_votes/1
  # PUT /feedback_votes/1.xml
  def update
    @feedback_vote = FeedbackVote.find(params[:id])

    respond_to do |format|
      if @feedback_vote.update_attributes(params[:feedback_vote])
        format.html { redirect_to(@feedback_vote, :notice => 'FeedbackVote was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feedback_vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feedback_votes/1
  # DELETE /feedback_votes/1.xml
  def destroy
    @feedback_vote = FeedbackVote.find(params[:id])
    @feedback_vote.destroy

    respond_to do |format|
      format.html { redirect_to(feedback_votes_url) }
      format.xml  { head :ok }
    end
  end
end
