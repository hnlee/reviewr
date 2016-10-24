class ReviewsController < ApplicationController
  before_action :require_project, only: [:new]

  def new
    @project = Project.find(params[:format])
    @review = Review.new
  end

  def create
    review = Review.new(content: review_params[:content])
    if review.save
      project_review = ProjectReview.create(project_id: review_params[:project_id],
                                            review_id: review.id)
      redirect_to project_path(review_params[:project_id])
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

  def require_project
    redirect_to projects_path unless params[:format]
  end
end
