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

  describe 'GET /projects/:id/reviews/:id' do
    it 'renders the template for the review show page' do
      project = create(:project)
      review = create(:review, project_id: project.id)

      get :show, params: { project_id: project.id,
                           id: review.id }

      expect(response.status).to eq(200)
      expect(response.body).to include(review.content)
    end

    it 'includes ratings associated with the review' do
      project = create(:project)
      review = create(:review, project_id: project.id)
      rating1 = create(:rating, review_id: review.id)
      rating2 = create(:rating, review_id: review.id)

      ["kind", "actionable", "specific"].each do |category|
         create(:rating_check, rating_id: rating1.id,
                               category: category,
                               value: true)
         create(:rating_check, rating_id: rating2.id,
                               category: category,
                               value: false)
      end

      get :show, params: { project_id: project.id,
                           id: review.id }

      expect(response.body).to include(rating1.id.to_s)
      expect(response.body).to include(rating2.id.to_s)

      expect(response.body).to include("Kind? Y")
      expect(response.body).to include("Actionable? Y")
      expect(response.body).to include("Specific? Y")

      expect(response.body).to include("Kind? N")
      expect(response.body).to include("Actionable? N")
      expect(response.body).to include("Specific? N")
    end
  end
end

