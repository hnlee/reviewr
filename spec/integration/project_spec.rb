require 'spec_helper'

describe 'project index page' do
  it 'shows all projects as links' do
    project1 = create(:project)
    project2 = create(:project, title: "Java Tic-Tac-Toe")

    visit "/"

    page.has_content? project1.title
    page.has_content? project2.title
  end
end
