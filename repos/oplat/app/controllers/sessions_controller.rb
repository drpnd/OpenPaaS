# -*- coding: utf-8 -*-
class SessionsController < ApplicationController

  def new
    render 'new'
  end

  def create
    user = User.find_by(name: params[:session][:name].downcase)
    if user && user.authenticate(params[:session][:password])
      # redirect
      sign_in user
      #redirect_to user
      redirect_to root_url
    else
      flash.now[:error] = 'Invalid name/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
