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
    review1 = create(:review, content: "Content1", project_id: project.id)
    review2 = create(:review, content: "Content2", project_id: project.id)
    review3 = create(:review, content: "Content3", project_id: project.id)

    expect(project.reviews.length).to eq(3)
  end
end
