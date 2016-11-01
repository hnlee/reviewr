require 'spec_helper'

describe 'rating', :type => :feature do
  describe 'new page' do
    it 'creates a new rating' do
      review = create(:review, content: 'This looks really good!')
      project = create(:project, title: "Foo", description: "Bar")
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit new_rating_path(review.id)
      choose('rating_helpful_true')
      click_button('Rate review')

      expect(page).to have_xpath('//i', :class => 'fa fa-thumbs-up')
      expect(page).to have_link('back to project')
    end

    it 'displays error message if radio button not selected' do
      review = create(:review, content: 'This looks really good!')

      visit new_rating_path(review.id)
      click_button('Rate review')

      expect(page).to have_content("Please select a button")
    end

    it 'displays error message if rated not helpful without any explanation' do
      review = create(:review, content: 'This looks really good!')

      visit new_rating_path(review.id)
      choose('rating_helpful_false')
      click_button('Rate review')

      expect(page).to have_content("Please provide an explanation")
    end

    it 'creates new rating if rated not helpful and explanation provided' do
      review = create(:review, content: 'This looks really good!')
      project = create(:project, title: "Foo", description: "Bar")
      create(:project_review, project_id: project.id,
                              review_id: review.id)
      explanation = 'Need to be more specific'

      visit new_rating_path(review.id)
      choose('rating_helpful_false')
      fill_in('rating_explanation', :with => explanation)
      click_button('Rate review')

      expect(page).to have_xpath('//i', :class => 'fa fa-thumbs-down')
      expect(page).to have_content(explanation)
    end

  end
end
