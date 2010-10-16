class AcceptancesController < ApplicationController

  before_filter :require_admin

  def index
    @talks = Talk.find(:all, :include => :users)
  end

end