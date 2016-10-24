class RatingsController < ApplicationController
  before_action :require_review, only: [:new]

  def new
    @review = Review.find(params[:format])
    @rating = Rating.new
  end

  def create
    rating = Rating.new(helpful: rating_params[:helpful])
    if rating.save
      review_rating = ReviewRating.create(review_id: rating_params[:review_id],
                                          rating_id: rating.id)
      redirect_to review_path(rating_params[:review_id])
    else
      redirect_to new_rating_path(rating_params[:review_id]), { flash: { error: "Please select a button" } }
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:helpful, :review_id)
  end

  def require_review
    redirect_to projects_path unless params[:format]
  end
end
