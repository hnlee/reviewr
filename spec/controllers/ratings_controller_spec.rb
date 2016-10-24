require 'spec_helper'

RSpec.describe RatingsController, :type => :controller do
  render_views

  describe 'GET /ratings/new' do
    it 'renders the new rating form' do
      review = create(:review, content: "Java Server")

      get :new, params: { format: review.id }

      expect(response.body).to include(review.content)
    end
  end

  describe 'POST /ratings' do
    it 'creates a new rating and redirects to the review show page' do
      review = create(:review, content: "Java Server")

      post :create, params: { rating: { helpful: true, review_id: review.id } }

      expect(response).to redirect_to(review)
      expect(response).to have_http_status(:redirect)
    end
  end
end
