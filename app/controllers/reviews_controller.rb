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

  def show
    @review = Review.find_by_id(params[:id]) 
    @ratings = @review.ratings
    @rating_checks = @ratings.group_by { |rating| rating.rating_checks }
  end

  private

  def review_params
    params.require(:review).permit(:content, :project_id)
  end
end
