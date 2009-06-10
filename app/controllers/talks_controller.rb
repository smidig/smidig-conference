class TalksController < ApplicationController
  before_filter :require_user, :except => [ :index, :show, :new, :create ]
  
  # GET /talks
  # GET /talks.xml
  def index
    @talks = params[:topic_id] ? Topic.find(params[:topic_id]).talks : Talk.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @talks }
      format.rss
    end
  end

  # GET /talks/1
  # GET /talks/1.xml
  def show
    @talk = Talk.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @talk }
    end
  end

  # GET /talks/new
  # GET /talks/new.xml
  def new
    @talk = Talk.new
    @talk.topic = Topic.find(params[:topic_id]) if params[:topic_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @talk }
    end
  end

  # GET /talks/1/edit
  def edit
    @talk = Talk.find(params[:id])
  end

  # POST /talks
  # POST /talks.xml
  def create
    @talk = Talk.new(params[:talk])
    @talk.speaker = current_user

    respond_to do |format|
      if @talk.save
        flash[:notice] = 'Talk was successfully created.'
        format.html { redirect_to(@talk) }
        format.xml  { render :xml => @talk, :status => :created, :location => @talk }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @talk.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /talks/1
  # PUT /talks/1.xml
  def update
    @talk = current_user.talks.find(params[:id])

    respond_to do |format|
      if @talk.update_attributes(params[:talk])
        flash[:notice] = 'Talk was successfully updated.'
        format.html { redirect_to(@talk) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @talk.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /talks/1
  # DELETE /talks/1.xml
  def destroy
    @talk = current_user.talks.find(params[:id])
    @talk.destroy

    respond_to do |format|
      format.html { redirect_to(talks_url) }
      format.xml  { head :ok }
    end
  end
  
protected
  def login_required
    return unless current_user
    flash[:error] = "Please log in to add your talk"
    access_denied
  end
  
end
