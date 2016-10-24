require 'spec_helper'

describe 'review', :type => :feature do
  describe 'show page with ratings' do
    it 'shows all ratings in a review' do
      review = create(:review, content: 'Looks good!')
      rating = create(:rating, helpful: true)
      create(:review_rating, review_id: review.id,
                             rating_id: rating.id)

      visit '/reviews/' + review.id.to_s

      expect(page).to have_content(review.content)
      expect(page).to have_xpath('//i', :class => 'fa fa-thumbs-up')
    end
  end

  describe 'new review page' do
    it 'displays a form for a new review' do
      project = create(:project, title: 'my title', description: 'my desc')

      visit '/reviews/new.' + project.id.to_s

      expect(page).to have_content('Create new review')
      expect(page).to have_css('form')
    end

    it 'redirects to the project show page when a review is submitted without content' do
      project = create(:project, title: 'my title', description: 'my desc')

      visit '/reviews/new.' + project.id.to_s
      fill_in('review[content]', with: 'my review')
      click_button('Submit')

      expect(current_path).to eq('/projects/' + project.id.to_s)
    end

    it 'reloads the page and displays a warning if content is left blank when creating a new review' do
      project = create(:project, title: 'my title', description: 'my desc')

      visit '/reviews/new.' + project.id.to_s
      click_button('Submit')

      expect(page).to have_content('Create new review')
      expect(page).to have_content('Review cannot be blank')
      expect(current_path).to eq('/reviews/new.' + project.id.to_s)
    end
  end
end
