require 'spec_helper'

describe 'project' do
  describe 'index page' do
    it 'shows all projects as links' do
      project1 = create(:project)
      project2 = create(:project, title: "Java Tic-Tac-Toe")

      visit "/"

      expect(page).to have_content(project1.title)
      expect(page).to have_content(project2.title)
    end

    it 'navigates to new project page when project link is clicked' do
      visit "/"
      click_link('+ create new project')

      expect(page).to have_css('form')
      expect(current_path).to eq('/projects/new')
    end

    it 'shows projects in reverse chronological order' do
      project1 = create(:project)
      project2 = create(:project, title: "Java Tic-Tac-Toe")

      visit "/"

      expect(page.body.index(project1.title)).to be > page.body.index(project2.title)
    end

    it 'shows a random review to be rated' do
      visit "/"

      expect(page).to have_content("Rate This Review")
    end

    it 'shows new rating form when thumbs up is clicked', :js => true do
      Capybara.ignore_hidden_elements = false

      visit "/"
      find_by_id('random-rating-up').trigger('click')

      expect(page).to have_css('form')
      expect(page).to have_checked_field('rating_helpful_true')
      expect(page).to have_button('Rate review')
    end

    it 'shows new rating form when thumbs down is clicked', :js => true do
      Capybara.ignore_hidden_elements = false

      visit "/"
      find_by_id('random-rating-down').trigger('click')

      expect(page).to have_css('form')
      expect(page).to have_checked_field('rating_helpful_false')
      expect(page).to have_button('Rate review')
    end

    it 'redirects to the index from the new rating form is cancel is hit', :js => true do
      Capybara.ignore_hidden_elements = false

      visit "/"
      find_by_id('random-rating-up').trigger('click')
      click_link('cancel')

      expect(current_path).to eq('/')
    end

    it 'redirects to the index from the new rating form when a new rating is submitted', :js => true do
      Capybara.ignore_hidden_elements = false

      visit "/"
      find_by_id('random-rating-up').trigger('click')
      find_by_id('submit-rating-button').trigger('click')

      expect(current_path).to eq('/')
    end

     it 'displays error message from index rating form if rated not helpful without any explanation', :js => true do
      Capybara.ignore_hidden_elements = false

      visit "/"
      find_by_id('random-rating-down').trigger('click')
      find_by_id('submit-rating-button').trigger('click')

      expect(current_path).to eq('/')
      expect(page).to have_content("Please provide an explanation")
    end
  end

  describe 'show page' do
    it 'shows the project title and description and link to new review' do
      project = create(:project, title: "my title", description: "my desc")

      visit "/projects/" + project.id.to_s

      expect(page).to have_content(project.title)
      expect(page).to have_content(project.description)
      expect(page).to have_content('+ review project')
    end

    it 'shows the reviews attached to the project' do
      project = create(:project, title: "my title", description: "my desc")
      review1 = create(:review, content: "great")
      review2 = create(:review, content: "terrible")
      project_review1 = create(:project_review, project_id: project.id,
                                                review_id: review1.id)
      project_review2 = create(:project_review, project_id: project.id,
                                                review_id: review2.id)

      visit "/projects/" + project.id.to_s

      expect(page).to have_content(review1.content)
      expect(page).to have_content(review2.content)
    end

    it 'loads new review partial when link is clicked', :js => true do
      project = create(:project, title: "my title", description: "my desc")

      visit "/projects/" + project.id.to_s
      click_link('+ review project')

      expect(page).to have_css('form')
      expect(current_path).to eq('/projects/' + project.id.to_s)
    end

    it 'navigates to edit project page when link is clicked' do
      project = create(:project, title: "my title", description: "my desc")

      visit "/projects/" + project.id.to_s
      click_link('edit-project-link')

      expect(page).to have_css('form')
    end

    it 'shows the reviews in reverse chronological order' do
      project = create(:project, title: "my title", description: "my desc")
      review1 = create(:review, content: "great")
      review2 = create(:review, content: "terrible")
      project_review1 = create(:project_review, project_id: project.id,
                                                review_id: review1.id)
      project_review2 = create(:project_review, project_id: project.id,
                                                review_id: review2.id)

      visit "/projects/" + project.id.to_s

      expect(page.body.index(review1.content)).to be > page.body.index(review2.content)
    end
  end

  describe 'new page' do
    it 'displays a form for a new project' do
      visit '/projects/new'

      expect(page).to have_css('form')
      expect(page).to have_content('Create new project')
      expect(page).to have_field('Title')
      expect(page).to have_field('Description')
      expect(page).to have_button('Create new project')
      expect(page).to have_content('This form supports markdown')
    end

    it 'redirects to the projects index page when a new project is submitted' do
      visit '/projects/new'
      fill_in('project[title]', with: 'my project')
      fill_in('project[description]', with: 'a description')
      click_button('Create new project')

      expect(current_path).to eq('/projects')
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
  end

  describe 'edit page' do
    it 'displays a form for editing a project' do
      project = create(:project, title: "my title", description: "my desc")
      
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
      
      visit '/projects/' + project.id.to_s + '/edit'
      fill_in('project[title]', with: '')
      fill_in('project[description]', with: 'new description')
      click_button('Update project')

      expect(current_path).to eq('/projects/' + project.id.to_s + '/edit')
      expect(page).to have_content('Please provide a title')
    end

    it 'displays a warning if project description is left blank' do
      project = create(:project, title: "my title", description: "my desc")
      
      visit '/projects/' + project.id.to_s + '/edit'
      fill_in('project[title]', with: 'new title')
      fill_in('project[description]', with: '')
      click_button('Update project')

      expect(current_path).to eq('/projects/' + project.id.to_s + '/edit')
      expect(page).to have_content('Please provide a description')
    end 
  end
end
