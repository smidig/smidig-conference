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

    @selected = params[:selected]

    @keynotes = [];
    @keynotes.push Talk.find(113)
    @keynotes.push Talk.find(114)

    respond_to do |format|
      format.html {render :layout => 'program' } # index.html.erb
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

  def workshop
                #[#sal][#slot]
    @workshops = [[],[],[]]

    #madonna
    @workshops[0][0] = Talk.find(71)
    @workshops[0][1] = Talk.find(39)
    @workshops[0][2] = Talk.find(73) #day 2
    @workshops[0][3] = Talk.find(15) #day 2

    #dracula
    @workshops[1][0] = Talk.find(85)
    @workshops[1][1] = Talk.find(36) #day 2
    @workshops[1][2] = Talk.find(62) #day 2

    #Kunst
    @workshops[2][0] = Talk.find(38) #day 2

    respond_to do |format|
      format.html {render :layout => 'program' } # index.html.erb
      format.xml
    end

  end

end
