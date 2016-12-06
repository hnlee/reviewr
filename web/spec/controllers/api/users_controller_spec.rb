require "spec_helper"

RSpec.describe Api::UsersController, :type => :controller do
  describe "GET /api/users/:id" do
    it "renders the user information in JSON" do 
      user = create(:user, name: "name",
                           email: "name@email.com",
                           uid: "uidname")

      get :show, params: { id: user.id }
      user_response = JSON.parse(response.body, symbolize_names: true)

      expect(user_response[:id]).to eq(user.id)
      expect(user_response[:email]).to eq(user.email)
      expect(user_response[:name]).to eq(user.name)
    end
  end
end
