require 'rails_helper'

RSpec.describe ProjectReview do
  it 'belongs to a project and a review' do
    project = create(:project)
    review = create(:review)
    project_review = ProjectReview.new(project_id: project.id,
                                       review_id: review.id)

    expect(project_review.project).to eq(project)
    expect(project_review.review).to eq(review)
  end
end
