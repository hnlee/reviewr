class UsersController < ApplicationController

  def show
    user = User.find_by_id(params[:id])
    if session[:user_id] != user.id
      redirect_to user_path(session[:user_id])
    else
      @user = current_user
      @review = Review.offset(rand(Review.count)).first
      @projects = @user.projects.order(updated_at: :desc).all
      @reviews = @user.reviews.order(updated_at: :desc).all
    end
  end
end
