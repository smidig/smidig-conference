class NametagsController < ApplicationController

  before_filter :require_admin

  def index
    @registrations = Registration.all

    prawnto :prawn => {
        :page_layout => :landscape,
        :page_size => 'A6',
        :left_margin=>0,
        :right_margin=>0,
        :top_margin=>0,
        :bottom_margin=>0 }
  end

  def show
    @registration = Registration.find(params[:id])

    prawnto :prawn => {
          :page_layout => :landscape,
          :page_size => 'A6',
          :left_margin=>0,
          :right_margin=>0,
          :top_margin=>0,
          :bottom_margin=>0 }
  end

end