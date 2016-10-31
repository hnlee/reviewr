require 'spec_helper'

describe 'review', :type => :feature do
  describe 'shows page with ratings' do
    it 'shows all ratings in a review' do
      review = create(:review, content: 'Looks good!')
      rating = create(:rating, helpful: true)
      create(:review_rating, review_id: review.id,
                             rating_id: rating.id)

      visit '/reviews/' + review.id.to_s

      expect(page).to have_content(review.content)
      expect(page).to have_xpath('//i', :class => 'fa fa-thumbs-up')
    end

    it 'loads new rating partial when link is clicked' do
      review = create(:review, content: 'Looks good!')

      visit "/reviews/" + review.id.to_s
      click_link('+ rate review')

      expect(page).to have_css('form')
    end

    it 'shows all ratings in reverse chronological order' do
      review = create(:review, content: 'Looks good!')
      rating1 = create(:rating, helpful: true)
      rating2 = create(:rating, helpful: false, explanation: 'Not specific')
      create(:review_rating, review_id: review.id,
                             rating_id: rating1.id)
      create(:review_rating, review_id: review.id,
                             rating_id: rating2.id)

      visit '/reviews/' + review.id.to_s
      
      expect(page.body.index('fa-thumbs-up')).to be > page.body.index('fa-thumbs-down')
    end
  end

  describe 'new review' do
    it 'displays a form for a new review' do
      project = create(:project, title: 'my title', description: 'my desc')

      visit '/projects/' + project.id.to_s
      click_link('+ review project')

      expect(page).to have_content('Create new review')
      expect(page).to have_css('form')
      expect(page).to have_content('This form supports markdown')
    end

    it 'redirects to the project show page when a review is submitted' do
      project = create(:project, title: 'my title', description: 'my desc')

      visit '/projects/' + project.id.to_s
      click_link('+ review project')
      fill_in('review[content]', with: 'my review')
      click_button('Submit')

      expect(current_path).to eq('/projects/' + project.id.to_s)
    end

    it 'displays a warning if content is left blank when creating a new review' do
      project = create(:project, title: 'my title', description: 'my desc')

      visit '/projects/' + project.id.to_s
      click_link('+ review project')
      click_button('Submit')

      expect(page).to have_content('Create new review')
      expect(page).to have_content('Review cannot be blank')
    end
  end

  describe 'edit review' do
    it 'displays a form to edit the review populated with the review content' do
      project = create(:project, title: 'my title', description: 'my desc')
      review = create(:review, content: 'Looks good!')
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit '/reviews/' + review.id.to_s
      click_link('edit-review-link')

      expect(page).to have_content('Edit review')
      expect(page).to have_content('This form supports markdown')
    end

    it 'reloads the review show page when a review is edited' do
      project = create(:project, title: 'my title', description: 'my desc')
      review = create(:review, content: 'Looks good!')
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit '/reviews/' + review.id.to_s
      click_link('edit-review-link')
      click_button('Submit')

      expect(current_path).to eq('/reviews/' + review.id.to_s)
      expect(page).to have_content('Review has been updated')
    end

    it 'reloads the page and displays a warning if content is left blank when creating a new review' do
      project = create(:project, title: 'my title', description: 'my desc')
      review = create(:review, content: 'Looks good!')
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit '/reviews/' + review.id.to_s
      click_link('edit-review-link')
      fill_in('review[content]', with: '')
      click_button('Submit')

      expect(page).to have_content('Review cannot be blank')
      expect(current_path).to eq('/reviews/' + review.id.to_s + '/edit')
    end
  end
end
