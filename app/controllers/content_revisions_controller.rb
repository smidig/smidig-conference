class ContentRevisionsController < ApplicationController  
  before_filter :content_required
  before_filter :login_required

  # GET /content_revisions
  # GET /content_revisions.xml
  def index
    @content_revisions = @content.content_revisions.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @content_revisions }
    end
  end

  # GET /content_revisions/1
  # GET /content_revisions/1.xml
  def show
    @content_revision = @content.content_revisions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @content_revision }
    end
  end

protected
  def authorized?
    logged_in? and current_user.can_edit? @content
  end
private
  def content_required
    @content = Content.find(params[:content_id]) unless params[:content_id].blank?
    if not @content
      flash[:error] = 'Content revision controller requires content'
      redirect_to '/'
    end
  end
end
