class RootController < ApplicationController

  def root 
    if session[:user_id].nil?
      render "logout" 
    else
      redirect_to user_path(session[:user_id])
    end
  end
end
