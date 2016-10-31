class RatingsController < ApplicationController

  def new
    @review = Review.find(params[:review_id])
    @rating = Rating.new
    if request.xhr?
      render partial: "ratings/new"
    end
  end

  def create
    rating = Rating.new(helpful: rating_params[:helpful],
                        explanation: rating_params[:explanation])
    if rating.save
      review_rating = ReviewRating.create(review_id: rating_params[:review_id],
                                          rating_id: rating.id)
      if request.xhr?
        render :js => "window.location = '#{review_path(rating_params[:review_id])}'"
      else
        redirect_to review_path(rating_params[:review_id])
      end
    else
      if rating.helpful == false and rating.explanation.blank?
        if request.xhr?
          render :js => "$('.alert-error').empty().append('<p>Please provide an explanation</p><br />');"
        else
          redirect_to new_rating_path(rating_params[:review_id]), { flash: { error: "Please provide an explanation" } }
        end
      else
        if request.xhr?
          render :js => "$('.alert-error').empty().append('<p>Please select a button</p><br />');"
        else
          redirect_to new_rating_path(rating_params[:review_id]), { flash: { error: "Please select a button" } }
        end
      end
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:helpful, :explanation, :review_id)
  end
end
