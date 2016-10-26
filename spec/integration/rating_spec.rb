require 'spec_helper'

describe 'rating', :type => :feature do
  describe 'new page' do
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

    it 'displays error message if rated not helpful without any explanation' do
      review = create(:review, content: 'This looks really good!')

      visit new_rating_path(review)
      choose('rating_helpful_false')
      click_button('Rate review')

      expect(page).to have_content("Please provide an explanation")
    end

    it 'creates new rating if rated not helpful and explanation provided' do
      review = create(:review, content: 'This looks really good!')
      explanation = 'Need to be more specific'

      visit new_rating_path(review)
      choose('rating_helpful_false')
      fill_in('rating_explanation', :with => explanation)
      click_button('Rate review')

      expect(page).to have_xpath('//i', :class => 'fa fa-thumbs-down')
      expect(page).to have_content(explanation)
    end

    it 'redirects to projects show if not from a review page' do
      visit new_rating_path

      expect(current_path).to eq(projects_path)
    end
  end
end
