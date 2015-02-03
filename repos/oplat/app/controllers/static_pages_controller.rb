class StaticPagesController < ApplicationController

  ## Front page
  def default
    render "static_pages/default"
  end

  def help
    render "static_pages/help"
  end

end
