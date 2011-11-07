# -*- encoding : utf-8 -*-
class ProgramController < ApplicationController

#  before_filter :require_admin, :only => [ :phone_list ]
  before_filter :require_admin

  def index
    @periods = Period.find(:all, :include => { :talks => :users })
    @periods_by_time_and_scene = Hash.new
    for p in @periods
      @periods_by_time_and_scene[p.time_id] ||= Hash.new
      @periods_by_time_and_scene[p.time_id][p.scene_id] = p 
    end

    @time_ids = @periods.collect { |p| p.time_id }.sort.uniq
    respond_to do |format|
      format.html # index.html.erb
      format.xml
    end
  end
  
  def phone_list
    @periods = Period.find(:all, :include => { :talks => :users })
    @periods_by_time_and_scene = Hash.new
    for p in @periods
      @periods_by_time_and_scene[p.time_id] ||= Hash.new
      @periods_by_time_and_scene[p.time_id][p.scene_id] = p 
    end

    @time_ids = @periods.collect { |p| p.time_id }.sort.uniq
    respond_to do |format|
      format.html # index.html.erb
      format.xml
    end
  
  end

end
