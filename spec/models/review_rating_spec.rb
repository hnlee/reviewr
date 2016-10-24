require 'rails_helper'

RSpec.describe ReviewRating do
  it 'belongs to a review and a rating' do
    review = create(:review)
    rating = create(:rating)
    review_rating = ReviewRating.new(rating_id: rating.id,
                                     review_id: review.id)

    expect(review_rating.review).to eq(review)
    expect(review_rating.rating).to eq(rating)
  end
end
