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

    it 'navigates to new project page when link is clicked' do
      visit "/"
      click_link('+ create new project')

      expect(page).to have_css('form')
      expect(current_path).to eq('/projects/new')
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

    it 'loads new review partial when link is clicked' do
      project = create(:project, title: "my title", description: "my desc")

      visit "/projects/" + project.id.to_s
      click_link('+ review project')

      expect(page).to have_css('form')
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
end
