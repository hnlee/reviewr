class UsersController < ApplicationController

  def show
    user = User.find_by_id(params[:id])
    if logged_out?
      redirect_to root_path
    elsif current_user != user 
      redirect_to user_path(current_user.id)
    else
      @user = current_user
      @review = Review.offset(rand(Review.count)).first
      @projects = @user.projects.order(updated_at: :desc).all
      @reviews = @user.reviews.order(updated_at: :desc).all
    end
  end
end
