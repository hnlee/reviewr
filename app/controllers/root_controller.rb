class RootController < ApplicationController

  def root 
    if logged_out? 
      render "logout" 
    else
      redirect_to user_path(current_user.id)
    end
  end
end
