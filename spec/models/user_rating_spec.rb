require 'rails_helper'

RSpec.describe UserRating do
  it 'belongs to a rating and a user' do
    rating = create(:rating, helpful: true)
    user = create(:user)
    user_rating = UserRating.new(rating_id: rating.id,
                                 user_id: user.id)

    expect(user_rating.user).to eq(user)
    expect(user_rating.rating).to eq(rating)
  end
end
