require 'spec_helper'

RSpec.describe ProjectsController, :type => :controller do
  render_views

  describe 'GET /' do
    it 'renders template for index' do
      project1 = create(:project)
      project2 = create(:project, title: "Java Tic-Tac-Toe")

      get :index

      expect(response.status).to eq(200)
      expect(response.body).to include(project1.title)
      expect(response.body).to include(project2.title)
    end
  end

  describe 'GET /projects/:id' do
    it 'renders the template for the project show page' do
      project = create(:project)

      get :show, params: { id: project.id }

      expect(response.status).to eq(200)
      expect(response.body).to include(project.title)
      expect(response.body).to include(project.description)
    end
  end
end

