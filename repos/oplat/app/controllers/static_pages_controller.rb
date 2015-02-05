class StaticPagesController < ApplicationController

  ## Front page
  def default
    @repositories = current_user.repositories.build if signed_in?
  end

  def help
    render "static_pages/help"
  end

end
