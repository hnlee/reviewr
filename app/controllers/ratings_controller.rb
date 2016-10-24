class RatingsController < ApplicationController
  before_action :require_review, only: [:new]

  def new
    @review = Review.find(params[:format])
    @rating = Rating.new
  end

  def create
    rating = Rating.new(helpful: rating_params[:helpful],
                        explanation: rating_params[:explanation])
    if rating.save
      review_rating = ReviewRating.create(review_id: rating_params[:review_id],
                                          rating_id: rating.id)
      redirect_to review_path(rating_params[:review_id])
    else
      if rating.helpful == false and rating.explanation.blank?
        redirect_to new_rating_path(rating_params[:review_id]), { flash: { error: "Please provide an explanation" } }
      else
        redirect_to new_rating_path(rating_params[:review_id]), { flash: { error: "Please select a button" } }
      end
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:helpful, :explanation, :review_id)
  end

  def require_review
    redirect_to projects_path unless params[:format]
  end
end
