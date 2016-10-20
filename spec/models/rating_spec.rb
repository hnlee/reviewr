require 'rails_helper'

RSpec.describe Rating, type: :model do
  it 'belongs to a review' do
    project = create(:project)
    review = create(:review, project_id: project.id)
    rating = Rating.new(review_id: review.id)

    expect(rating.review).to eq(review)
  end

  it 'has ratings' do
    project = create(:project)
    review = create(:review, project_id: project.id)
    rating = Rating.create(review_id: review.id)
    kind = create(:rating_check, rating_id: rating.id,
                                 category: "kind",
                                 value: true)

    expect(rating.rating_checks).to include(kind)
  end
end
