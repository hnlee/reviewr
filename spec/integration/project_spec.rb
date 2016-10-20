require 'spec_helper'

describe 'project' do
  describe 'project index page' do
    it 'shows all projects as links' do
      project1 = create(:project)
      project2 = create(:project, title: "Java Tic-Tac-Toe")

      visit "/"

      page.has_content? project1.title
      page.has_content? project2.title
    end
  end

  describe 'project show page' do
    it 'shows the project title and description' do
      project = create(:project, title: "my title", description: "my desc")

      visit "/projects/" + project.id.to_s

      page.has_content? project.title
      page.has_content? project.description
    end
  end
end
