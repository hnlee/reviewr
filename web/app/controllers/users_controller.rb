class UsersController < ApplicationController

  def show
    user = User.find_by_id(params[:id])
    if logged_out?
      redirect_to root_path
    elsif current_user != user 
      redirect_to user_path(current_user.id)
    else
      @user = current_user
      @review = Review.get_random_review(@user)
      @projects = @user.projects.order(updated_at: :desc).all
      @reviews = @user.reviews.order(updated_at: :desc).all
      @invites = @user.get_open_invites.sort_by(&:updated_at).reverse
      @create = params[:create]
      if @create == "success"
        flash.now[:notice] = "Rating has been created"
      end
    end
  end
end
