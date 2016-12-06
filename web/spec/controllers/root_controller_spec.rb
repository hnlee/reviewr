require "spec_helper"

RSpec.describe RootController, :type => :controller do
  render_views

  describe "GET /" do
    it "renders the logout template when user is not logged in" do
      session[:user_id] = nil

      get :root

      expect(response).to have_http_status(200)
      expect(response.body).to include("Sign in with Google")
    end
    
    it "redirects you to user show page when user is logged in" do
      session[:user_id] = create(:user).id

      get :root

      expect(response).to have_http_status(:redirect)
    end
  end
end
