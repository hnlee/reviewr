require 'spec_helper'

RSpec.describe ReviewsController, :type => :controller do
  render_views

  describe 'GET /reviews/new' do
    it 'renders the template for the review new page' do
      project = create(:project)
      invite = create(:user)
      create(:project_invite, project_id: project.id,
                              user_id: invite.id)
      session[:user_id] = invite.id

      get :new, params: { project_id: project.id }

      expect(response.body).to include(project.title)
      expect(response.body).to include("Create new review")
    end
  end

  describe 'POST /reviews/new' do
    it 'creates a new review and redirects to the project show page' do
      project = create(:project, title: "Java Tic-Tac-Toe", description: "TTT, you'll love it")
      reviewer = create(:user)
      session[:user_id] = reviewer.id

      post :create, params: { review: { content: "This looks good", project_id: project.id }, project_id: project.id }

      expect(response).to have_http_status(:redirect)
    end

    it 'reloads form with a flash warning when the content is left blank' do
      project = create(:project, title: "Java Tic-Tac-Toe", description: "TTT, you'll love it")
      reviewer = create(:user)
      session[:user_id] = reviewer.id

      post :create, params: { review: { content: "", project_id: project.id }, project_id: project.id }

      expect(response).to redirect_to('/reviews/new/' + project.id.to_s)
      expect(response).to have_http_status(:redirect)
      expect(flash[:error]).to match('Review cannot be blank')
    end
 end

  describe 'GET /reviews/:id' do
    describe 'when logged out' do
      it 'redirects to root path' do
      end
    end
    describe 'when logged in as user who is not the reviewer' do
      it 'shows the review content' do
      end
    end
    describe 'when logged in as the reviewer' do
      it 'shows the review and ratings associated with the review' do
        reviewer = create(:user)
        project = create(:project, title: "Foo", description: "Bar")
        review = create(:review, content: "Java code retreat")
        rating = create(:rating, helpful: true)
        create(:project_review, project_id: project.id,
                                review_id: review.id)
        create(:review_rating, review_id: review.id,
                               rating_id: rating.id)
        create(:user_review, user_id: reviewer.id,
                             review_id: review.id)
        session[:user_id] = reviewer.id

        get :show, params: { id: review.id }

        expect(response.body).to include(review.content)
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET /reviews/:id/edit' do
    describe 'when logged out' do
      it 'redirects to root' do
      end
    end
    describe 'when logged in as user who is not reviewer' do
      it 'redirects to user show page' do
      end
    end
    describe 'when logged in as the reviewer' do
      it 'renders a form populated with the current review content' do
        reviewer = create(:user)
        review = create(:review, content: "This is really great")
        create(:user_review, user_id: reviewer.id,
                             review_id: review.id)
        session[:user_id] = reviewer.id

        get :edit, params: { id: review.id }

        expect(response.body).to include(review.content)
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'POST /reviews/:id/edit' do
    it 'edits the review and redirects to the show page' do
      review = create(:review)

      post :update, params: { id: review.id, review: { content: 'review content'} }
      
      updated_review = Review.find_by_id(review.id)
      expect(response).to redirect_to(review_path(review.id))
      expect(response).to have_http_status(:redirect)
      expect(updated_review.content).to eq('review content')
      expect(flash[:notice]).to match("Review has been updated")
    end

    it 'displays flash error message if content is blank' do
      review = create(:review)

      post :update, params: { id: review.id, review: { content: '' } }
      
      expect(response).to redirect_to(edit_review_path(review.id))
      expect(flash[:error]).to match("Review cannot be blank")
    end
  end
end
