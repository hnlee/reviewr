require 'spec_helper'

describe 'review', :type => :feature do
  describe 'show page' do
    describe 'when logged out' do
      it 'redirects to root' do
        review = create(:review, content: 'Looks good!')
        project = create(:project, title: "Foo", description: "Bar")
        create(:project_review, project_id: project.id,
                                review_id: review.id)

        visit "/reviews/" + review.id.to_s

        expect(current_path).to eq('/')
      end 
    end

    describe 'when logged in as a user who is not the reviewer' do
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: 'uidhillaryclinton',
                                   info: { name: 'hillaryclinton',
                                           email: 'hillaryclinton@email.com' } })
        @user = User.find_by_name('hillaryclinton')
        @review = create(:review, content: 'Looks good!')
        project = create(:project, title: "Foo", description: "Bar")
        reviewer = create(:user, name: 'name1',
                                 email: 'name1@email.com',
                                 uid: 'uidname1')
        create(:project_review, project_id: project.id,
                                review_id: @review.id)
        create(:user_review, user_id: reviewer.id,
                             review_id: @review.id)

        visit "/"
        find_link("Sign in with Google").click
      end

      it 'shows review content and link to leave rating' do
        visit '/reviews/' + @review.id.to_s

        expect(page).to have_content(@review.content)
        expect(page).to have_xpath('//i', :class => 'fa fa-thumbs-up')
        expect(page).to have_link('back to project')
       end

      it 'does not show ratings left by other people' do
        rating = create(:rating, helpful: true,
                                 explanation: 'Great!')
        rater = create(:user, name: 'name3',
                              email: 'name3@email.com',
                              uid: 'uidname3')
        create(:review_rating, review_id: @review.id,
                               rating_id: rating.id)
        create(:user_rating, user_id: rater.id,
                             rating_id: rating.id)

        visit '/reviews/' + @review.id.to_s

        expect(page).not_to have_content(rating.explanation)
       end

     it 'does show ratings left by logged in user' do
        rating = create(:rating, helpful: true,
                                 explanation: 'Great!')
        create(:review_rating, review_id: @review.id,
                               rating_id: rating.id)
        create(:user_rating, user_id: @user.id,
                             rating_id: rating.id)

        visit '/reviews/' + @review.id.to_s

        expect(page).to have_content(rating.explanation)
      end

      it 'loads new rating partial when thumbs up is clicked, with thumbs up preselected', :js => true do
        Capybara.ignore_hidden_elements = false

        visit "/reviews/" + @review.id.to_s
        find_by_id('new-rating-up').trigger('click')

        expect(page).to have_css('form')
        expect(page).to have_content('Rate review')
        expect(page).to have_checked_field('rating_helpful_true')
        expect(page).to have_button('Rate review')
      end

      it 'loads new rating partial when thumbs down is clicked, with thumbs down preselected', :js => true do
        Capybara.ignore_hidden_elements = false

        visit "/reviews/" + @review.id.to_s
        find_by_id('new-rating-down').trigger('click')

        expect(page).to have_css('form')
        expect(page).to have_content('Rate review')
        expect(page).to have_checked_field('rating_helpful_false')
        expect(page).to have_button('Rate review')
      end
    end

    describe 'when logged in as the reviewer' do
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: 'uidhillaryclinton',
                                   info: { name: 'hillaryclinton',
                                           email: 'hillaryclinton@email.com' } })
        @reviewer = User.find_by_name('hillaryclinton')
        @review = create(:review, content: 'Looks good!')
        project = create(:project, title: "Foo", description: "Bar")
        create(:project_review, project_id: project.id,
                                review_id: @review.id)
        create(:user_review, user_id: @reviewer.id,
                             review_id: @review.id)

        visit "/"
        find_link("Sign in with Google").click
      end

      it 'shows all ratings for a review' do
        rating = create(:rating, helpful: true)
        create(:review_rating, review_id: @review.id,
                               rating_id: rating.id)

        visit '/reviews/' + @review.id.to_s

        expect(page).to have_content(@review.content)
        expect(page).to have_xpath('//i', :class => 'fa fa-thumbs-up')
        expect(page).to have_link('back to project')
      end
     
      it 'shows all ratings in reverse chronological order' do
        rating1 = create(:rating, helpful: true, explanation: 'Nice')
        rating2 = create(:rating, helpful: false, explanation: 'Not specific')
        create(:review_rating, review_id: @review.id,
                               rating_id: rating1.id)
        create(:review_rating, review_id: @review.id,
                               rating_id: rating2.id)

        visit '/reviews/' + @review.id.to_s
        
        expect(page.body.index('Nice')).to be > page.body.index('Not specific')
      end

      it 'loads partial to edit the review populated with the review content', :js => true do
        visit '/reviews/' + @review.id.to_s
        find_by_id('edit-review-link').trigger('click')

        expect(page).to have_content('Update review')
        expect(current_path).to eq('/reviews/' + @review.id.to_s)
      end

      xit 'navigates to the project page when the back link is clicked' do
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
  end

  describe 'new page' do
    xit 'redirects to the project show page when a review is submitted' do
      project = create(:project, title: 'my title', description: 'my desc')

      visit '/projects/' + project.id.to_s
      click_link('+ review project')
      fill_in('review[content]', with: 'my review')
      click_button('Create new review')

      expect(current_path).to eq('/projects/' + project.id.to_s)
      expect(page).to have_content('my review')
    end

    xit 'displays a warning if content is left blank when creating a new review', :js => true do
      project = create(:project, title: 'my title', description: 'my desc')

      visit '/projects/' + project.id.to_s
      click_link('+ review project')
      click_button('Create new review')

      expect(page).to have_content('Create new review')
      expect(page).to have_content('Review cannot be blank')
      expect(current_path).to eq('/projects/' + project.id.to_s)
    end

    xit 'redirects back to the project show page when cancel link is clicked', :js => true do
      project = create(:project, title: 'my title', description: 'my desc')

      visit '/projects/' + project.id.to_s
      click_link('+ review project')
      click_link('cancel')

      expect(current_path).to eq('/projects/' + project.id.to_s)
      expect(page).to have_no_css('form')
    end
   end

  describe 'edit page' do
    describe 'when logged out' do
      it 'redirects to root' do
        review = create(:review, content: 'Looks good!')
        project = create(:project, title: "Foo", description: "Bar")
        create(:project_review, project_id: project.id,
                                review_id: review.id)

        visit "/reviews/" + review.id.to_s + "/edit"

        expect(current_path).to eq('/')
      end
    end

    describe 'when logged in as a user who is not the reviewer' do
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: 'uidhillaryclinton',
                                   info: { name: 'hillaryclinton',
                                           email: 'hillaryclinton@email.com' } })
        @user = User.find_by_name('hillaryclinton')
        reviewer = create(:user, name: 'name1',
                                 email: 'name1@email.com',
                                 uid: 'uidname1')
        project = create(:project, title: "Foo", description: "Bar")
        @review = create(:review, content: 'Looks good!')
        create(:project_review, project_id: project.id,
                                review_id: @review.id)
        create(:user_review, user_id: reviewer.id,
                             review_id: @review.id)

        visit "/"
        find_link("Sign in with Google").click
      end

      it 'redirects to user show page' do
        visit '/reviews/' + @review.id.to_s + '/edit'

        expect(current_path).to eq('/users/' + @user.id.to_s)
      end
    end

    describe 'when logged in as reviewer' do
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: 'uidhillaryclinton',
                                   info: { name: 'hillaryclinton',
                                           email: 'hillaryclinton@email.com' } })
        @reviewer = User.find_by_name('hillaryclinton')
        @review = create(:review, content: 'Looks good!')
        project = create(:project, title: "Foo", description: "Bar")
        create(:project_review, project_id: project.id,
                                review_id: @review.id)
        create(:user_review, user_id: @reviewer.id,
                             review_id: @review.id)

        visit "/"
        find_link("Sign in with Google").click
      end

      it 'reloads the review show page when a review is edited' do
        visit '/reviews/' + @review.id.to_s
        click_link('edit-review-link')
        fill_in('review[content]', with: 'FUBAR')
        click_button('Update review')

        expect(current_path).to eq('/reviews/' + @review.id.to_s)
        expect(page).to have_content('Review has been updated')
        expect(page).to have_content('FUBAR')
        expect(page).not_to have_content('Looks good!')
      end

     it 'displays a warning if content is left blank when editing a new review', :js => true do
        visit '/reviews/' + @review.id.to_s
        find_by_id('edit-review-link').trigger('click')
        fill_in('review[content]', with: '')
        click_button('Update review')

        expect(page).to have_content('Review cannot be blank')
        expect(current_path).to eq('/reviews/' + @review.id.to_s)
      end

      it 'redirects back to review show page when cancel link is clicked', :js => true do
        visit '/reviews/' + @review.id.to_s
        find_by_id('edit-review-link').trigger('click')
        click_link('cancel')

        expect(current_path).to eq('/reviews/' + @review.id.to_s)
        expect(page).to have_no_css('form')
        expect(page).to have_content('Looks good!')
      end
    end
  end
end
