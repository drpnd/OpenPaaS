# -*- coding: utf-8 -*-
class UserKeysController < ApplicationController

  def new
    wd = ENV['OPLAT_OPLAT_GITOLITE_REPOSITORY']
    @user_keys[:key] = File.read("#{wd}/keydir/#{current_user.name}.pub")
    render 'new'
  end

  def update
  end

end
