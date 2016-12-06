require "spec_helper"

RSpec.describe SessionsController, :type => :controller do
  render_views

  describe "GET /auth/google_oauth2/callback" do
    it "authenticates and redirects" do
      auth_hash = { uid: "uid",
                    info: { name: "name", 
                            email: "email" } }
      request.env["omniauth.auth"] = auth_hash

      process :create

      expect(response).to have_http_status(:redirect)
      expect(session[:user_id]).not_to be_nil 
    end
  end

  describe "GET /logout" do
    it "logs you out and redirects you to root" do
      session[:user_id] = "uid"

      process :destroy

      expect(session[:user_id]).to be_nil
      expect(response).to have_http_status(:redirect)
    end
  end
end
