class FeedbackVotesController < ApplicationController
  # GET /feedback_votes
  # GET /feedback_votes.xml
  def index
    @feedback_votes = FeedbackVote.all

    respond_to do |format|
      format.html # index.html.erb
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
        format.html { redirect_to(@feedback_vote, :notice => 'FeedbackVote was successfully created.') }
        format.xml  { render :xml => @feedback_vote, :status => :created, :location => @feedback_vote }
      else
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
