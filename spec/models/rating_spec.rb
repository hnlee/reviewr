require 'rails_helper'

RSpec.describe Rating do
  it 'has helpful boolean set' do
    rating = Rating.new(helpful: true)

    expect(rating.helpful).to eq(true)
  end

  it 'does not save if helpful field is not set' do
    rating = Rating.create(helpful: nil)

    expect(rating.id).to eq(nil)
  end

  it 'has an explanation field that can be set' do
    explanation = 'This review is not kind, specific, or actionable.'
    rating = Rating.new(helpful: false,
                        explanation: explanation) 

    expect(rating.explanation).to eq(explanation)
  end

  it 'does not save if helpful is false and explanation is blank' do
    rating = Rating.create(helpful: false,
                           explanation: '')
    
    expect(rating.id).to eq(nil)
  end

  it 'has one user who gave the rating' do
    rating = Rating.create(helpful: true)
    user = create(:user)
    create(:user_rating, user_id: user.id,
                         rating_id: rating.id)

    expect(rating.user).to eq(user)
  end
end
