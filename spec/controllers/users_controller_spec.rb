require 'spec_helper'

RSpec.describe UsersController, :type => :controller do
  render_views

  describe 'GET /users/:id' do
    before(:each) do
      @user = create(:user, name: 'User Name', email: 'username@example.com')
      session[:user_id] = @user.id
    end

    it 'displays the user show page' do
      get :show, params: { id: @user.id }

      expect(response.status).to eq(200)
      expect(response.body).to include(@user.name)
    end

    it 'displays the user owned projects' do
      project1 = create(:project, title: 'Project 1 Title')
      project2 = create(:project, title: 'Project 2 Title')
      create(:project_owner, project_id: project1.id, user_id: @user.id)
      create(:project_owner, project_id: project2.id, user_id: @user.id)

      get :show, params: { id: @user.id }

      expect(response.body).to include(project1.title)
      expect(response.body).to include(project1.title)
    end

    it 'displays the reviews that the user has written' do
      review1 = create(:review, content: 'Review 1 content')
      review2 = create(:review, content: 'Review 2 content')
      create(:user_review, review_id: review1.id, user_id: @user.id)
      create(:user_review, review_id: review2.id, user_id: @user.id)

      get :show, params: { id: @user.id }

      expect(response.body).to include(review1.content)
      expect(response.body).to include(review2.content)
    end
  end
end