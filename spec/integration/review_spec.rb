require 'spec_helper'

describe 'review', :type => :feature do
  describe 'show page' do
    it 'shows all ratings for a review' do
      review = create(:review, content: 'Looks good!')
      rating = create(:rating, helpful: true)
      project = create(:project, title: "Foo", description: "Bar")
      create(:project_review, project_id: project.id,
                              review_id: review.id)
      create(:review_rating, review_id: review.id,
                             rating_id: rating.id)

      visit '/reviews/' + review.id.to_s

      expect(page).to have_content(review.content)
      expect(page).to have_xpath('//i', :class => 'fa fa-thumbs-up')
      expect(page).to have_link('back to project')
    end

    it 'loads new rating partial when thumbs up is clicked, with thumbs up preselected', :js => true do
      Capybara.ignore_hidden_elements = false
      review = create(:review, content: 'Looks good!')
      project = create(:project, title: "Foo", description: "Bar")
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit "/reviews/" + review.id.to_s
      find_by_id('new-rating-up').trigger('click')

      expect(page).to have_css('form')
      expect(page).to have_content('Rate review')
      expect(page).to have_checked_field('rating_helpful_true')
      expect(page).to have_button('Rate review')
    end

    it 'loads new rating partial when thumbs down is clicked, with thumbs down preselected', :js => true do
      Capybara.ignore_hidden_elements = false
      review = create(:review, content: 'Looks good!')
      project = create(:project, title: "Foo", description: "Bar")
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit "/reviews/" + review.id.to_s
      find_by_id('new-rating-down').trigger('click')

      expect(page).to have_css('form')
      expect(page).to have_content('Rate review')
      expect(page).to have_checked_field('rating_helpful_false')
      expect(page).to have_button('Rate review')
    end
    
    it 'shows all ratings in reverse chronological order' do
      review = create(:review, content: 'Looks good!')
      rating1 = create(:rating, helpful: true, explanation: 'Nice')
      rating2 = create(:rating, helpful: false, explanation: 'Not specific')
      project = create(:project, title: "Foo", description: "Bar")
      create(:project_review, project_id: project.id,
                              review_id: review.id)
      create(:review_rating, review_id: review.id,
                             rating_id: rating1.id)
      create(:review_rating, review_id: review.id,
                             rating_id: rating2.id)

      visit '/reviews/' + review.id.to_s
      
      expect(page.body.index('Nice')).to be > page.body.index('Not specific')
    end

    it 'loads partial to edit the review populated with the review content', :js => true do
      project = create(:project, title: 'my title', description: 'my desc')
      review = create(:review, content: 'Looks good!')
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit '/reviews/' + review.id.to_s
      find_by_id('edit-review-link').trigger('click')

      expect(page).to have_content('Update review')
      expect(current_path).to eq('/reviews/' + review.id.to_s)
    end

    it 'navigates to the project page when the back link is clicked' do
      project = create(:project, title: 'my title', description: 'my desc')
      review = create(:review, content: 'Looks good!')
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit '/reviews/' + review.id.to_s
      click_link('back to project')

      expect(page).to have_content(project.title)
      expect(current_path).to eq('/projects/' + project.id.to_s)
    end
  end

  describe 'new page' do
    it 'redirects to the project show page when a review is submitted' do
      project = create(:project, title: 'my title', description: 'my desc')

      visit '/projects/' + project.id.to_s
      click_link('+ review project')
      fill_in('review[content]', with: 'my review')
      click_button('Create new review')

      expect(current_path).to eq('/projects/' + project.id.to_s)
      expect(page).to have_content('my review')
    end

    it 'displays a warning if content is left blank when creating a new review', :js => true do
      project = create(:project, title: 'my title', description: 'my desc')

      visit '/projects/' + project.id.to_s
      click_link('+ review project')
      click_button('Create new review')

      expect(page).to have_content('Create new review')
      expect(page).to have_content('Review cannot be blank')
      expect(current_path).to eq('/projects/' + project.id.to_s)
    end
   end

  describe 'edit page' do
    it 'reloads the review show page when a review is edited' do
      project = create(:project, title: 'my title', description: 'my desc')
      review = create(:review, content: 'Looks good!')
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit '/reviews/' + review.id.to_s
      click_link('edit-review-link')
      click_button('Update review')

      expect(current_path).to eq('/reviews/' + review.id.to_s)
      expect(page).to have_content('Review has been updated')
    end

   it 'displays a warning if content is left blank when editing a new review', :js => true do
      project = create(:project, title: 'my title', description: 'my desc')
      review = create(:review, content: 'Looks good!')
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit '/reviews/' + review.id.to_s
      find_by_id('edit-review-link').trigger('click')
      fill_in('review[content]', with: '')
      click_button('Update review')

      expect(page).to have_content('Review cannot be blank')
      expect(current_path).to eq('/reviews/' + review.id.to_s)
    end
  end
end
