require 'rails_helper'

RSpec.describe UserReview do
  it 'belongs to a review and a user' do
    review = create(:review)
    user = create(:user)
    user_review = UserReview.new(review_id: review.id,
                                 user_id: user.id)

    expect(user_review.user).to eq(user)
    expect(user_review.review).to eq(review)
  end
end
