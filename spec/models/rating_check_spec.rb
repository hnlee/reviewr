require 'rails_helper'

RSpec.describe RatingCheck, type: :model do
  it 'belongs to a rating' do
    project = create(:project)
    review = create(:review, project_id: project.id)
    rating = create(:rating, review_id: review.id)
    kind = RatingCheck.create(rating_id: rating.id,
                              category: "kind",
                              value: true)

    expect(kind.rating).to eq(rating)
  end

  it 'needs a category' do
    project = create(:project)
    review = create(:review, project_id: project.id)
    rating = create(:rating, review_id: review.id)
    kind = RatingCheck.create(rating_id: rating.id,
                              value: true)

    expect(kind.id).to eq(nil)
  end

  it 'needs a value' do
    project = create(:project)
    review = create(:review, project_id: project.id)
    rating = create(:rating, review_id: review.id)
    kind = RatingCheck.create(rating_id: rating.id,
                              category: "kind")

    expect(kind.id).to eq(nil)
  end
end
