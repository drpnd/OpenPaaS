class StaticPagesController < ApplicationController

  ## Front page
  def default
  end

  def help
    render "static_pages/help"
  end

end
