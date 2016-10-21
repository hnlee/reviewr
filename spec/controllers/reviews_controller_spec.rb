require 'spec_helper'

RSpec.describe ReviewsController, :type => :controller do
  render_views

  describe 'POST /reviews/new' do
    it 'creates a new review and redirects to the project show page' do
      project = create(:project, title: "Java Tic-Tac-Toe", description: "TTT, you'll love it")

      post :create, params: { review: { content: "This looks good", project_id: project.id }, project_id: project.id }

      expect(response).to redirect_to(project)
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'GET /reviews/:id' do
    it 'shows a review and ratings associated with the review' do
      review = create(:review, content: "Java code retreat")
      rating = create(:rating, kind: true, actionable: true, specific: true)
      create(:review_rating, review_id: review.id,
                             rating_id: rating.id)

      get :show, params: { id: review.id }

      expect(response.body).to include(review.content)
      expect(response.status).to eq(200)
    end
  end
end
