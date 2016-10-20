require 'spec_helper'

describe 'review' do
  describe 'project show page with reviews' do
    it 'shows all reviews in a project' do
      project = create(:project, title: "Java Tic-Tac-Toe")
      review = create(:review, content: "Looks good!", project_id: project.id)

      visit '/projects/' + project.id.to_s

      expect(page).to have_content(project.title)
      expect(page).to have_content(project.description)
      expect(page).to have_content(review.content)
    end
  end

  describe 'review can be created' do
    it 'creates a new review' do
      project = create(:project, title: "Java Tic-Tac-Toe")
      content = 'This looks really good!'
      new_review_page = '/projects/' + project.id.to_s + '/reviews/new'

      visit new_review_page
      fill_in new_review_page[content], with: content, visible: false
      click_button('Submit')

      expect(page).to have_content(content)
    end
  end
end
