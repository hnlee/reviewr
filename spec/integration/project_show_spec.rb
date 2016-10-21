require 'spec_helper'

describe 'review', :type => :feature do
  describe 'project show page with reviews' do
    it 'shows all reviews in a project' do
      project = create(:project, title: "Java Tic-Tac-Toe")
      review = create(:review, content: "Looks good!")
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit '/projects/' + project.id.to_s

      expect(page).to have_content(project.title)
      expect(page).to have_content(project.description)
      expect(page).to have_content(review.content)
    end
  end

  describe 'can be created' do
    it 'creates a new review' do
      project = create(:project, title: "Java Tic-Tac-Toe")
      content = 'This looks really good!'

      visit new_review_path(project)
      fill_in 'review_content', :with => content
      click_button('Submit')

      expect(page).to have_content(content)
    end
  end

  describe 'if not from a project page' do
    it 'redirects to project index' do
      visit new_review_path

      expect(current_path).to eq(projects_path)
    end
  end
end
