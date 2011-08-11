# -*- encoding : utf-8 -*-
class NametagsController < ApplicationController

  before_filter :require_admin

  def index
    @registrations = Registration.all

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
