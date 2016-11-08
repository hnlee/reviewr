require 'spec_helper'

describe 'rating', :type => :feature do
  before(:each) do
    OmniAuth.config.add_mock(:google_oauth2,
                             { uid: 'uidhillaryclinton',
                               info: { name: 'hillaryclinton',
                                       email: 'hillaryclinton@email.com' } })
    @user = User.find_by_name('hillaryclinton')

    visit '/'
    click_link('Sign in with Google')
  end

  
  describe 'new page' do
    it 'redirects to the review show page when a rating is submitted', :js => true do
      user = create(:user, name: 'Name', email: 'name@example.com')
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
      user = create(:user, name: 'Name', email: 'name@example.com')
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
    
    it 'redirects to the review show page if cancel link is hit', :js => true do
      review = create(:review, content: 'This looks really good!')
      project = create(:project, title: "Foo", description: "Bar")
      create(:project_review, project_id: project.id,
                              review_id: review.id)

      visit '/reviews/' + review.id.to_s
      find_by_id('new-rating-down').trigger('click')
      click_link('cancel')

      expect(current_path).to eq('/reviews/' + review.id.to_s)
      expect(page).to have_no_css('form') 
    end
  end

  describe 'random new page' do
    it 'redirects to the index from the new rating form is cancel is hit', :js => true do
      Capybara.ignore_hidden_elements = false

      visit user_path(id: @user.id)
      find_by_id('random-rating-up').trigger('click')
      click_link('cancel')

      expect(current_path).to eq('/users/' + @user.id.to_s)
      expect(page).to have_no_css('form')
    end

    it 'redirects to the index from the new rating form when a new rating is submitted', :js => true do
      Capybara.ignore_hidden_elements = false
      user = create(:user, name: 'Name', email: 'name@example.com')

      visit user_path(id: user.id)
      find_by_id('random-rating-up').trigger('click')
      find_by_id('submit-rating-button').trigger('click')

      expect(current_path).to eq('/users/' + user.id.to_s)
    end

     it 'displays error message from index rating form if rated not helpful without any explanation', :js => true do
      Capybara.ignore_hidden_elements = false
      user = create(:user, name: 'Name', email: 'name@example.com')

      visit user_path(id: user.id)
      find_by_id('random-rating-down').trigger('click')
      find_by_id('submit-rating-button').trigger('click')

      expect(current_path).to eq('/users/' + user.id.to_s)
      expect(page).to have_content("Please provide an explanation")
    end
  end
end
