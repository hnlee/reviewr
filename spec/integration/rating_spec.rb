require 'spec_helper'

describe 'rating', :type => :feature do
  describe 'link to new rating page' do
    it 'creates a new rating' do
      review = create(:review, content: 'This looks really good!')

      visit new_rating_path(review)
      choose('rating_helpful_true')
      click_button('Rate review')

      expect(page).to have_content("Kind, specific, actionable: true")
    end
  end

  describe 'if not from a review page' do
    it 'redirects to projects show' do
      visit new_rating_path

      expect(current_path).to eq(projects_path)
    end
  end
end
