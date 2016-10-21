require 'rails_helper'

RSpec.describe Project do
  it 'has a title and description' do
    project = Project.new(title: "My Title",
                          description: "My Description")

    expect(project.title).to eq("My Title")
    expect(project.description).to eq("My Description")
  end

  it 'has many reviews' do
    project = Project.create(title: "My Title",
                             description: "My Description")
    review1 = create(:review, content: "Content1")
    review2 = create(:review, content: "Content2")
    review3 = create(:review, content: "Content3")
    create(:project_review, project_id: project.id,
                            review_id: review1.id)
    create(:project_review, project_id: project.id,
                            review_id: review2.id)
    create(:project_review, project_id: project.id,
                            review_id: review3.id)

    expect(project.project_reviews.length).to eq(3)
  end
end
