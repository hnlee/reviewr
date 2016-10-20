class ReviewsController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
    @review = Review.new
  end

  def create
    project = Project.find(review_params[:project_id])
    review = Review.new(review_params)
    review.project = project
    if review.save
      redirect_to project
    else
      render "new"
    end
  end

  private
  def review_params
    params.require(:review).permit(:content, :project_id)
  end
end
