class PeriodsController < ApplicationController
  before_filter :require_admin, :except => [ :index, :show ]
  
  # GET /periods
  # GET /periods.xml
  def index
    @periods = Period.find(:all, :include => { :talks => :users })
    @periods_by_time_and_scene = Hash.new
    for p in @periods
      @periods_by_time_and_scene[p.time_id] ||= Hash.new
      @periods_by_time_and_scene[p.time_id][p.scene_id] = p 
    end

    @time_ids = @periods.collect { |p| p.time_id }.sort.uniq
    
    @edit = params[:edit] && admin?
    @all_talks = Talk.all(:order => 'id', :include => :users) if @edit
    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @periods }
    end
  end
  
  def make_program
    periods = params[:periods]
    talk_params = {}    
    periods.each_pair do
      |period_id,period_params|
      period_params[:position].each_pair do
        |position,talk_id|
        next if talk_id.blank?
        talk_params[talk_id.to_i] = { :period_id => period_id.to_i, :position => position.to_i }
      end
    end
    
    Talk.transaction do      
      for talk in Talk.all(:include => :topic)
        if talk_params[talk.id]
          talk.period_id = talk_params[talk.id][:period_id]
          talk.position = talk_params[talk.id][:position]
        else
          talk.period_id = nil
          talk.position = nil
        end
        talk.save!
      end
    end
    
    redirect_to periods_path(:edit => true)
  end
  

  # GET /periods/1
  # GET /periods/1.xml
  def show
    @period = Period.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @period }
    end
  end

  # GET /periods/new
  # GET /periods/new.xml
  def new
    @period = Period.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @period }
    end
  end

  # GET /periods/1/edit
  def edit
    @period = Period.find(params[:id])
  end

  # POST /periods
  # POST /periods.xml
  def create
    @period = Period.new(params[:period])

    respond_to do |format|
      if @period.save
        flash[:notice] = 'Period was successfully created.'
        format.html { redirect_to(@period) }
        format.xml  { render :xml => @period, :status => :created, :location => @period }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /periods/1
  # PUT /periods/1.xml
  def update
    @period = Period.find(params[:id])

    respond_to do |format|
      if @period.update_attributes(params[:period])
        flash[:notice] = 'Period was successfully updated.'
        format.html { redirect_to(@period) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /periods/1
  # DELETE /periods/1.xml
  def destroy
    @period = Period.find(params[:id])
    @period.destroy

    respond_to do |format|
      format.html { redirect_to(periods_url) }
      format.xml  { head :ok }
    end
  end
end
