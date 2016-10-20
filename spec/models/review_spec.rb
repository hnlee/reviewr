require 'rails_helper'

RSpec.describe Review do
  it 'has content' do
    project = create(:project)
    review = Review.new(content: "Looks good!", project_id: project.id)

    expect(review.content).to eq("Looks good!")
    expect(review.project_id).to eq(project.id)
  end

  it 'belongs to a project' do
    project = create(:project)
    review = Review.new(content: "Looks good!", project_id: project.id)

    expect(review.project).to eq(project)
  end
end
