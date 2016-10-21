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

    it 'includes reviews associated with the project' do
      project = create(:project)
      review1 = create(:review, content: "Looks good!")
      review2 = create(:review, content: "Huh?")
      create(:project_review, project_id: project.id,
                              review_id: review1.id)
      create(:project_review, project_id: project.id,
                              review_id: review2.id)

      get :show, params: { id: project.id }

      expect(response.body).to include(review1.content)
      expect(response.body).to include(review2.content)
    end
  end
end
