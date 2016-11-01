require 'spec_helper'

describe 'rating', :type => :feature do
  describe 'new page', :js => true do
    it 'redirects to the review show page when a rating is submitted' do
      review = create(:review, content: 'This looks really good!')
      project = create(:project, title: "Foo", description: "Bar")
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit '/reviews/' + review.id.to_s
      find_by_id('new-rating-up').trigger('click')
      click_button('Rate review')

      expect(page).to have_xpath('//i', :class => 'fa fa-thumbs-up')
      expect(current_path).to eq('/reviews/' + review.id.to_s)
    end

   it 'displays error message on page if rated not helpful without any explanation', :js => true do
      review = create(:review, content: 'This looks really good!')
      project = create(:project, title: "Foo", description: "Bar")
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit '/reviews/' + review.id.to_s
      find_by_id('new-rating-down').trigger('click')
      click_button('Rate review')

      expect(current_path).to eq('/reviews/' + review.id.to_s)
      expect(page).to have_content("Please provide an explanation")
    end

    it 'creates new rating if rated not helpful and explanation provided', :js => true do
      review = create(:review, content: 'This looks really good!')
      project = create(:project, title: "Foo", description: "Bar")
      create(:project_review, project_id: project.id,
                              review_id: review.id)
      explanation = 'Need to be more specific'

      visit '/reviews/' + review.id.to_s
      find_by_id('new-rating-down').trigger('click')
      fill_in('rating_explanation', :with => explanation)
      click_button('Rate review')

      expect(page).to have_xpath('//i', :class => 'fa fa-thumbs-down')
      expect(page).to have_content(explanation)
    end
  end
end
