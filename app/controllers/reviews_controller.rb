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
      if request.xhr?
        project_review = ProjectReview.create(project_id: review_params[:project_id],
                                              review_id: review.id)
        render :js => "window.location = '#{project_path(review_params[:project_id])}'"
      else
        redirect_to new_review_path(review_params[:project_id]), {:flash => { :error => "Review cannot be blank" }}
      end
    else
      redirect_to new_review_path(review_params[:project_id]), {:flash => { :error => "Review cannot be blank" }}
    end
  end

  def show
    @review = Review.find(params[:id])
    @ratings = @review.ratings
  end

  private

  def review_params
    params.require(:review).permit(:content, :project_id)
  end

end
