# -*- encoding : utf-8 -*-
class ProgramController < ApplicationController

  before_filter :require_admin, :only => [ :phone_list ]

  def index
    @periods = Period.find(:all, :include => { :talks => :users })
    @periods_by_time_and_scene = Hash.new
    for p in @periods
      @periods_by_time_and_scene[p.time_id] ||= Hash.new
      @periods_by_time_and_scene[p.time_id][p.scene_id] = p 
    end

    @time_ids = @periods.collect { |p| p.time_id }.sort.uniq

    @w = Array.new
    @w[0] = [Talk.find(11), Talk.find(97)]
    @w[1] = [Talk.find(35), Talk.find(88)]
    @w[2] = [Talk.find(35), Talk.find(89)]
    @w[3] = [Talk.find(41), Talk.find(36)]
    @w[4] = [Talk.find(43), Talk.find(36)]
    @w[5] = [Talk.find(24), Talk.find(82)]

    @selected = params[:selected]

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
