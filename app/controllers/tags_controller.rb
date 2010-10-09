class TagsController < ApplicationController
  before_filter :require_user, :only => [:new, :create]
  before_filter :require_admin, :only => [:edit, :update, :destroy]
  # Anybody can see :index & :show

  # GET /tags
  def index
    @tags = Tag.find(:all)
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def new
    @tag = Tag.new
  end

  def edit
  end

  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        flash[:notice] = 'Opprettet tag.'
        format.html { redirect_to(@tag) }
      else
        format.html { render :action => "new" }
      end
    end
  end


  def update
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
  end

end
