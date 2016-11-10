require 'spec_helper'

describe 'project' do
  describe 'show page' do
    describe 'when logged out' do
      it 'redirects to root' do
        project = create(:project, title: "my title", description: "my desc")
        owner = create(:user, name: 'name',
                              email: 'name@email.com',
                              uid: 'uidname')
        create(:project_owner, project_id: project.id,
                               user_id: owner.id)

        visit "/projects/" + project.id.to_s

        expect(current_path).to eq('/')
      end
    end

    describe 'when logged in as user who is not the owner' do
      it 'redirects to user show page' do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: 'uidhillaryclinton',
                                   info: { name: 'hillaryclinton',
                                           email: 'hillaryclinton@email.com' } })

        visit "/"
        find_link("Sign in with Google").click

        project = create(:project, title: "my title", description: "my desc")
        owner = create(:user, name: 'name',
                              email: 'name@email.com',
                              uid: 'uidname')
        create(:project_owner, project_id: project.id,
                               user_id: owner.id)
        @user = User.find_by_name('hillaryclinton')

        visit "/projects/" + project.id.to_s

        expect(current_path).to eq("/users/" + @user.id.to_s)
      end
    end

    describe 'when logged in as the owner' do
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: 'uidhillaryclinton',
                                   info: { name: 'hillaryclinton',
                                           email: 'hillaryclinton@email.com' } })
        @user = User.find_by_name('hillaryclinton')
        @project = create(:project, title: "my title", description: "my desc")
        create(:project_owner, project_id: @project.id,
                               user_id: @user.id)

        visit "/"
        find_link("Sign in with Google").click
      end

      it 'shows the project title and description' do
        visit "/projects/" + @project.id.to_s

        expect(page).to have_content(@project.title)
        expect(page).to have_content(@project.description)
      end

      it 'does not show the link to leave a new review' do
        visit "/projects/" + @project.id.to_s

        expect(page).not_to have_content('+ review project')
      end

      it 'shows the reviews attached to the project' do
        review1 = create(:review, content: "great")
        review2 = create(:review, content: "terrible")
        project_review1 = create(:project_review, project_id: @project.id,
                                                  review_id: review1.id)
        project_review2 = create(:project_review, project_id: @project.id,
                                                  review_id: review2.id)

        visit "/projects/" + @project.id.to_s

        expect(page).to have_content(review1.content)
        expect(page).to have_content(review2.content)
      end

      it 'navigates to edit project page when link is clicked' do
        visit "/projects/" + @project.id.to_s
        click_link('edit-project-link')

        expect(page).to have_css('form')
      end

      it 'shows the reviews in reverse chronological order' do
        review1 = create(:review, content: "great")
        review2 = create(:review, content: "terrible")
        project_review1 = create(:project_review, project_id: @project.id,
                                                  review_id: review1.id)
        project_review2 = create(:project_review, project_id: @project.id,
                                                  review_id: review2.id)

        visit "/projects/" + @project.id.to_s

        expect(page.body.index(review1.content)).to be > page.body.index(review2.content)
      end
    end
  end

  describe 'new page' do
    describe 'when logged out' do
      it 'redirects you to the root' do
        visit '/projects/new'

        expect(current_path).to eq('/')
      end
    end

    describe 'when logged in' do
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: 'uidhillaryclinton',
                                   info: { name: 'hillaryclinton',
                                           email: 'hillaryclinton@email.com' } })
        @user = User.find_by_name('hillaryclinton')

        visit "/"
        find_link("Sign in with Google").click
      end

      it 'displays a form for a new project' do
        visit '/projects/new'

        expect(page).to have_css('form')
        expect(page).to have_content('Create new project')
        expect(page).to have_field('Title')
        expect(page).to have_field('Description')
        expect(page).to have_button('Create new project')
        expect(page).to have_content('This form supports markdown')
      end

      it 'redirects to the user show page when a new project is submitted' do
        visit '/projects/new'
        fill_in('project[title]', with: 'my project')
        fill_in('project[description]', with: 'a description')
        click_button('Create new project')

        expect(current_path).to eq('/users/' + @user.id.to_s)
        expect(page).to have_content('my project')
      end

      it 'displays a warning if title is left blank when creating a new project' do
        visit '/projects/new'
        fill_in('project[description]', with: 'a description')
        click_button('Create new project')

        expect(current_path).to eq('/projects/new')
        expect(page).to have_content('Create new project')
        expect(page).to have_content('Please provide a title')
      end

      it 'displays a warning if description is left blank when creating a new project' do
        visit '/projects/new'
        fill_in('project[title]', with: 'my project')
        click_button('Create new project')

        expect(current_path).to eq('/projects/new')
        expect(page).to have_content('Create new project')
        expect(page).to have_content('Please provide a description')
      end

      it 'redirects to user show page if cancel link is clicked' do
        visit '/projects/new'
        click_link('cancel')

        expect(current_path).to eq('/users/' + @user.id.to_s)
        expect(page).to have_no_css('form')
      end
    end
  end

  describe 'edit page' do
    describe 'when not logged in' do
      it 'redirects to the root' do
        project = create(:project, title: "my title", description: "my desc")

        visit '/projects/' + project.id.to_s + '/edit'

        expect(current_path).to eq('/')
      end
    end
    describe 'when logged in as the project owner' do
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: 'uidhillaryclinton',
                                   info: { name: 'hillaryclinton',
                                           email: 'hillaryclinton@email.com' } })
        @user = User.find_by_name('hillaryclinton')

        visit "/"
        find_link("Sign in with Google").click
      end

      it 'displays a form for editing a project' do
        project = create(:project, title: "my title", description: "my desc")
        create(:project_owner, project_id: project.id,
                               user_id: @user.id)

        visit '/projects/' + project.id.to_s + '/edit'

        expect(page).to have_css('form')
        expect(page).to have_content('Update project')
        expect(page).to have_field('Title', with: "my title")
        expect(page).to have_field('Description')
        expect(page).to have_content("my desc")
        expect(page).to have_button('Update project')
        expect(page).to have_content('This form supports markdown')
      end

      it 'redirects to the project show page after a project is edited and shows a flash notice' do
        project = create(:project, title: "my title", description: "my desc")
        create(:project_owner, project_id: project.id,
                               user_id: @user.id)

        visit '/projects/' + project.id.to_s + '/edit'
        fill_in('project[title]', with: 'new title')
        fill_in('project[description]', with: 'new description')
        click_button('Update project')

        expect(current_path).to eq('/projects/' + project.id.to_s)
        expect(page).to have_content('new title')
        expect(page).to have_content('new description')
        expect(page).to have_content('Project has been updated')
      end

      it 'displays a warning if project title is left blank' do
        project = create(:project, title: "my title", description: "my desc")
        create(:project_owner, project_id: project.id,
                               user_id: @user.id)

        visit '/projects/' + project.id.to_s + '/edit'
        fill_in('project[title]', with: '')
        fill_in('project[description]', with: 'new description')
        click_button('Update project')

        expect(current_path).to eq('/projects/' + project.id.to_s + '/edit')
        expect(page).to have_content('Please provide a title')
      end

      it 'displays a warning if project description is left blank' do
        project = create(:project, title: "my title", description: "my desc")
        create(:project_owner, project_id: project.id,
                               user_id: @user.id)

        visit '/projects/' + project.id.to_s + '/edit'
        fill_in('project[title]', with: 'new title')
        fill_in('project[description]', with: '')
        click_button('Update project')

        expect(current_path).to eq('/projects/' + project.id.to_s + '/edit')
        expect(page).to have_content('Please provide a description')
      end

      it 'redirects to project show page if cancel link is clicked' do
        project = create(:project, title: "my title", description: "my desc")
        create(:project_owner, project_id: project.id,
                               user_id: @user.id)

        visit '/projects/' + project.id.to_s + '/edit'
        click_link('cancel')

        expect(current_path).to eq('/projects/' + project.id.to_s)
        expect(page).to have_no_css('form')
        expect(page).to have_content('my title')
        expect(page).to have_content('my desc')
      end
    end
  end
end
