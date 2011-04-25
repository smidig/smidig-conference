class CommentsController < ApplicationController
  before_filter :require_user, :only => [ :new, :create, :edit ]
  
  # GET /comments
  # GET /comments.xml
  def index
    @comments = params[:talk_id] ? Talk.find(params[:talk_id]).comments : Comment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
      format.rss
    end
  end
  
  def show
    @comment = Comment.find(params[:id], :include => [:talk])
    redirect_to :controller => 'talks', :action => 'show', :id => @comment.talk, :anchor => dom_id(@comment)
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @talk = Talk.find(params[:talk_id])
    @comment = @talk.comments.new(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Kommentaren har blitt opprettet.'
        SmidigMailer.comment_notification(@comment,
          talk_url(@comment.talk, :anchor => dom_id(@comment))).deliver
        format.html { redirect_to(:controller => 'talks', :action => 'show', :id => @talk, :anchor => dom_id(@comment)) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :template => "talks/show" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
end
