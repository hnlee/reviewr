require 'spec_helper'

RSpec.describe ReviewsController, :type => :controller do
  render_views

  describe 'POST /projects/:id/reviews/new' do
    it 'creates a new review and redirects to the project show page' do
      project = create(:project, title: "Java Tic-Tac-Toe", description: "TTT, you'll love it")

      post :create, params: { review: { content: "This looks good", project_id: project.id }, project_id: project.id }

      expect(response).to redirect_to(project)
      expect(response).to have_http_status(:redirect)
    end
  end
end