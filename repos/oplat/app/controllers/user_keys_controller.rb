# -*- coding: utf-8 -*-
class UserKeysController < ApplicationController
  before_action :signed_in_user, only: [:new, :update]

  def new
    wd = ENV['OPLAT_OPLAT_GITOLITE_REPOSITORY']
    key = File.read("#{wd}/keydir/#{current_user.name}.pub")
    @user_keys = { :key => key, :x => 0 }
    #render 'new'
  end

  def create
    logger.info params[:key]

  end

end
