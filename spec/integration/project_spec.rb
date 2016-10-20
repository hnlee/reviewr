require 'spec_helper'

describe 'project' do
  describe 'project index page' do
    it 'shows all projects as links' do
      project1 = create(:project)
      project2 = create(:project, title: "Java Tic-Tac-Toe")

      visit "/"

      expect(page).to have_content(project1.title)
      expect(page).to have_content(project2.title)
    end
  end

  describe 'project show page' do
    it 'shows the project title and description' do
      project = create(:project, title: "my title", description: "my desc")

      visit "/projects/" + project.id.to_s

      expect(page).to have_content(project.title)
      expect(page).to have_content(project.description)
      expect(page).to have_content('new review')
    end

    it 'navigates to new review page when link is clicked' do
      project = create(:project, title: "my title", description: "my desc")

      visit "/projects/" + project.id.to_s
      click_link('new review')

      expect(page).to have_css('form')
    end
  end
end
