# Controller for displaying static html pages
# See http://railscasts.com/episodes/117-semi-static-pages for details
class InfoController < ApplicationController
  before_filter :applyCacheControl

  def applyCacheControl
    response.headers['Cache-Control'] = 'public, max-age=3600'
  end

  # Page cache for all views.
  # See http://www.railsenvy.com/2007/2/28/rails-caching-tutorial for details
  #caches_page :index, :arrangoerene, :lyntaler, :openspace
	
end

