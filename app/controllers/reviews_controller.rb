class ReviewsController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
    @review = Review.new
    if request.xhr?
      render partial: "reviews/new"
    end
  end

  def create
    review = Review.new(content: review_params[:content])
    if review.save
      ProjectReview.create(project_id: review_params[:project_id],
                                            review_id: review.id)
      UserReview.create(review_id: review.id, user_id: current_user.id)
      if request.xhr?
        render :js => "url.redirectToURI('#{project_path(review_params[:project_id])}')"
      else
        redirect_to project_path(review_params[:project_id])
      end
    else
      if request.xhr?
        render :js => "dom.replaceContent('.alert-error', '<p>Review cannot be blank</p><br />');"
      else
        redirect_to new_review_path(review_params[:project_id]), {:flash => { :error => "Review cannot be blank" }}
      end
    end
  end

  def edit
    @review = Review.find(params[:id])
    if logged_out?
      redirect_to root_path
    else
      if current_user != @review.user
        redirect_to user_path(current_user.id)
      elsif request.xhr?
        render partial: "reviews/edit"
      else
      end
    end
  end

  def update
    @review = Review.find(params[:id])
    if @review.update_attributes(review_params)
      if request.xhr?
        render :js => "url.redirectToURI('#{review_path(params[:id], update: "success")}');"
      else
        redirect_to @review, { :flash => { :notice => "Review has been updated" } }
      end
    else
      if request.xhr?
        render :js => "dom.replaceContent('.alert-error', '<p>Review cannot be blank</p><br />');"
      else
        redirect_to edit_review_path, {:flash => { :error => "Review cannot be blank" }}
      end
    end
  end

  def show
    @review = Review.find(params[:id])
    if logged_out?
      redirect_to root_path
    else
      @user = current_user
      if current_user == @review.user
        @ratings = @review.ratings.order(updated_at: :desc)
      else
        @ratings = Rating.get_user_owned_ratings(@user, @review)
      end
      @project = @review.project
      @update = params[:update]
      if @update == "success"
        flash.now[:notice] = "Review has been updated"
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :project_id)
  end
end
