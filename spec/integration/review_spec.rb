require 'spec_helper'

describe 'project show page with reviews' do
  it 'shows all reviews in a project' do
    project = create(:project, title: "Java Tic-Tac-Toe")
    review = create(:review, content: "Looks good!", project_id: project.id)

    visit '/projects/' + project.id.to_s

    page.has_content? project.title
    page.has_content? project.description
    page.has_content? review.content
  end
end
