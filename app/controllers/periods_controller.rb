# -*- encoding : utf-8 -*-
class PeriodsController < ApplicationController
 # before_filter :require_admin, :except => [ :index, :show ]
  before_filter :require_admin
  
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
    @all_talks = Talk.all_pending_and_approved if @edit
    @all_talks.sort!{|t1,t2|t1.id <=> t2.id}

    respond_to do |format|
      format.html {render :layout => 'plain' }# index.html.erb
      format.xml  { render :xml => @periods }
    end
  end
  
  def make_program
    periods = params[:periods]

    dups = []
    changed = []

    Talk.transaction do      
      periods.each_pair do
        |period_id,period_params|
        positions = period_params[:positions]
        positions.each_pair do
          |position,period_properties|
          new_talk = period_properties[:new_talk]
          previous_talk = period_properties[:previous_talk]
          Talk.update_all "period_id = null, position = null", [ "id = ?", previous_talk.to_i ] unless
              new_talk == previous_talk || previous_talk.blank?
        end
        positions.each_pair do
          |position,period_properties|
          new_talk = period_properties[:new_talk]
          previous_talk = period_properties[:previous_talk]
          Talk.update_all [ "period_id = ?, position = ?", period_id.to_i, position.to_i], [ "id = ?", new_talk.to_i ] unless
            new_talk == previous_talk || new_talk.blank?
          
          dups << new_talk.to_i if (new_talk != previous_talk && changed.include?(new_talk.to_i))
          changed << new_talk.to_i if (new_talk != previous_talk)
        end
        flash[:warn] = "Duplikate endringer" unless dups.empty?
      end
      periods.each_pair do
        |period_id,period_params|
        new_title = period_params[:new_title]
        previous_title = period_params[:previous_title]
        Period.update_all [ "title = ?", new_title ], [ "id = ?", period_id.to_i ] unless new_title == previous_title
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
