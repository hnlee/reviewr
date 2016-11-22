require "spec_helper"

RSpec.describe RatingsController, :type => :controller do
  render_views

  describe "GET /ratings/new" do
    it "renders the new rating form" do
      review = create(:review, content: "Java Server")
      user = create(:user, name: "Name", email: "name@example.com", uid: "uidname")
      session[:user_id] = user.id

      get :new, params: { review_id: review.id, user: user.id }

      expect(response.body).to include(review.content)
      expect(response.body).to include("Is this review kind, specific, and actionable?")
    end
  end

  describe "POST /ratings/new" do
    it "creates a new rating and redirects to the review show page" do
      review = create(:review, content: "Java Server")
      user = create(:user, name: "Name", email: "name@example.com", uid: "uidname")
      session[:user_id] = user.id

      post :create, params: { rating: { helpful: true, review_id: review.id } }

      expect(response).to redirect_to(review)
      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to match("Rating has been created")
    end

    it "displays flash message if radio button not selected" do
      review = create(:review, content: "Java Server")
      user = create(:user, name: "Name", email: "name@example.com", uid: "uidname")
      session[:user_id] = user.id

      post :create, params: { rating: { helpful: nil, review_id: review.id } }

      expect(response).to redirect_to(new_rating_path(review))
      expect(flash[:error]).to match("Please select a button")
    end

    it "displays flash message if helpful is set to false and explanation is blank" do
      review = create(:review, content: "Java Server")
      user = create(:user, name: "Name", email: "name@example.com", uid: "uidname")
      session[:user_id] = user.id

      post :create, params: { rating: { helpful: false,
                                        explanation: "",
                                        review_id: review.id } }

      expect(response).to redirect_to(new_rating_path(review))
      expect(flash[:error]). to match("Please provide an explanation")
    end
  end
end
