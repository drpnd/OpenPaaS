# -*- coding: utf-8 -*-
class UserKeysController < ApplicationController
  before_action :signed_in_user, only: [:new, :update]

  def new
    wd = ENV['OPLAT_OPLAT_GITOLITE_REPOSITORY']
    @key = File.read("#{wd}/keydir/#{current_user.name}.pub")
  end

  def create
    key = params[:key]
    cmd = "sudo -u '#{ENV['OPLAT_OPLAT_GITOLITE_USER'].shellescape}' #{Rails.root}/scripts/update_user.rb #{current_user.name.shellescape} #{key.shellescape}"
    r = system( cmd )
    if r
      flash[:success] = "Updated the SSH key!"
      redirect_to root_url
    else
      flash.now[:error] = 'Failed'
      redirect_to new_user_keys_url
    end
  end

end
