require 'rails_helper'

RSpec.describe Review do
  it 'has content' do
    review = Review.new(content: "Looks good!")

    expect(review.content).to eq("Looks good!")
  end

  it 'has many ratings' do
    review = Review.create(content: "Amazing")
    rating1 = create(:rating, helpful: true)
    rating2 = create(:rating, helpful: false, 
                              explanation: "not specific")
    create(:review_rating, review_id: review.id,
                           rating_id: rating1.id)
    create(:review_rating, review_id: review.id,
                           rating_id: rating2.id)

    expect(review.ratings.length).to eq(2)
  end

  it 'has one user who wrote the review' do
    review = Review.create(content: "Terrible")
    user = create(:user, name: 'Sally',
                         email: 'sally@email.com',
                         password: 'password')
    create(:user_review, user_id: user.id, 
                         review_id: review.id)
                         
    expect(review.user).to eq(user)
  end
end
