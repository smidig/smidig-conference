# -*- encoding : utf-8 -*-
class NametagsController < ApplicationController

  before_filter :require_admin

  def index
    start_id = params[:start_id] || "0";
    @registrations = Registration.find(:all, :conditions => 'id >= ' +start_id)
    @registrations += @registrations if params.has_key? "double"
    @registrations.sort! { |a, b| a.user.name <=> b.user.name }

    prawnto :prawn => {
        :page_layout => :portrait,
        :page_size => 'A6',
        :margin=>0 }
  end

  def show
    @registration = Registration.find(params[:id])

    prawnto :prawn => {
          :page_layout => :portrait,
          :page_size => 'A6',
          :margin => 0 }
  end

end
