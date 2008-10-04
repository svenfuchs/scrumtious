class SessionsController < ApplicationController
  def create
    session[:current_user_id] = params[:current_user][:id]
    redirect_back '/'
  end
end