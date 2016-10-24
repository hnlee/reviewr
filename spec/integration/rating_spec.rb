require 'spec_helper'

describe 'rating', :type => :feature do
  describe 'link to new rating page' do
    it 'creates a new rating' do
      review = create(:review, content: 'This looks really good!')

      visit new_rating_path(review)
      choose('rating_helpful_true')
      click_button('Rate review')

      expect(page).to have_xpath('//i', :class => 'fa fa-thumbs-up')
    end

    it 'displays error message if radio button not selected' do
      review = create(:review, content: 'This looks really good!')

      visit new_rating_path(review)
      click_button('Rate review')

      expect(page).to have_content("Please select a button")
    end
  end

  describe 'if not from a review page' do
    it 'redirects to projects show' do
      visit new_rating_path

      expect(current_path).to eq(projects_path)
    end
  end
end
