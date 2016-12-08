require "spec_helper"

RSpec.describe ProjectsController, :type => :controller do
  render_views

  before(:all) {
    DatabaseCleaner.strategy = :truncation
  }

  after(:all) {
    DatabaseCleaner.clean
  }

  describe "GET projects/new" do
    it "redirects to root if not logged in" do
      get :new

      expect(response).to have_http_status(:redirect)
    end

    it "renders the template for the project new page if logged in" do
      user = create(:user)
      session[:user_id] = user.id

      get :new

      expect(response.body).to include("Title")
      expect(response.body).to include("Link")
      expect(response.body).to include("Description")
      expect(response.body).to include("Enter email address to invite reviewer")
    end
  end

  describe "POST /projects/new" do
    before(:each) do
      @user = create(:user)
      session[:user_id] = @user.id
    end

    it "creates a new project and redirects to the user show page" do
      post :create, params: { project: { title: "my project", 
                                         link: "http://link.link",
                                         description: "a description" },
                              emails: ["an@email.com"] }

      expect(response).to redirect_to(user_path(session[:user_id]))
      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to match("Project has been created")
    end

   it "displays flash message if title is blank" do
      post :create, params: { project: { title: "",
                                         link: "http://link.link", 
                                         description: "a description" } }

      expect(response).to redirect_to(new_project_path)
      expect(flash[:error]).to match("Please provide a title")
    end

    it "displays flash message if link is blank" do
      post :create, params: { project: { title: "my project", 
                                         link: "",
                                         description: "a description" } }

      expect(response).to redirect_to(new_project_path)
      expect(flash[:error]).to match("Please provide a link")
    end

    it "displays flash message if description is blank" do
      post :create, params: { project: { title: "my project", 
                                         link: "http://link.link",
                                         description: "" } }

      expect(response).to redirect_to(new_project_path)
      expect(flash[:error]).to match("Please provide a description")
    end
  end

  describe "GET /projects/:id" do
    it "redirects to root if you are not logged in" do
      project = create(:project)

      get :show, params: { id: project.id }

      expect(response).to have_http_status(:redirect)
    end

    it "redirects to root if you are not logged in as the owner, invited reviewer, or previous reviewer" do
      project = create(:project)
      owner = create(:user, name: "name1",
                            email: "name1@email.com",
                            uid: "uidname1")
      user = create(:user, name: "name2",
                           email: "name2@email.com",
                           uid: "uidname2")
      create(:project_owner, project_id: project.id,
                             user_id: owner.id)
      session[:user_id] = user.id

      get :show, params: { id: project.id }

      expect(response).to have_http_status(:redirect)
    end

    it "renders the template for the project show page when logged in as an invited reviewer" do
      project = create(:project)
      review = create(:review, content: "What a project")
      reviewer = create(:user, name: "name1",
                               email: "name1@email.com",
                               uid: "uidname1")
      invite = create(:user, name: "name2",
                             email: "name2@email.com",
                             uid: "uidname2")
      create(:project_invite, project_id: project.id,
                              user_id: invite.id)
      create(:project_review, project_id: project.id,
                              review_id: review.id)
      create(:user_review, user_id: reviewer.id,
                           review_id: review.id)
      session[:user_id] = invite.id

      get :show, params: { id: project.id }

      expect(response.status).to eq(200)
      expect(response.body).to include(project.title)
      expect(response.body).to include(project.link)
      expect(response.body).to include(project.description)
      expect(response.body).not_to include(review.content)
      expect(response.body).not_to include(invite.email)
    end

    it "renders the template for the project show page when logged in as a previous reviewer" do
      project = create(:project)
      review = create(:review, content: "What a project")
      reviewer = create(:user, name: "name1",
                               email: "name1@email.com",
                               uid: "uidname1")
      invite = create(:user, name: "name2",
                             email: "name2@email.com",
                             uid: "uidname2")
      create(:project_invite, project_id: project.id,
                              user_id: invite.id)
      create(:project_review, project_id: project.id,
                              review_id: review.id)
      create(:user_review, user_id: reviewer.id,
                           review_id: review.id)
      session[:user_id] = reviewer.id

      get :show, params: { id: project.id }

      expect(response.status).to eq(200)
      expect(response.body).to include(project.title)
      expect(response.body).to include(project.link)
      expect(response.body).to include(project.description)
      expect(response.body).to include(review.content)
      expect(response.body).not_to include(invite.email)
    end

    it "renders the template for the project show page when logged in as the owner" do
      project = create(:project)
      owner = create(:user, name: "name1",
                            email: "name1@email.com",
                            uid: "uidname1")
      invite = create(:user, name: "name2",
                             email: "name2@email.com",
                             uid: "uidname2")
      create(:project_owner, project_id: project.id,
                             user_id: owner.id)
      create(:project_invite, project_id: project.id,
                              user_id: invite.id)
      session[:user_id] = owner.id

      get :show, params: { id: project.id }

      expect(response.status).to eq(200)
      expect(response.body).to include(project.title)
      expect(response.body).to include(project.link)
      expect(response.body).to include(project.description)
      expect(response.body).to include(invite.email)
    end

    it "includes helpfully rated reviews associated with the project when logged in as the owner" do
      project = create(:project)
      owner = create(:user, name: "name",
                            email: "name@email.com",
                            uid: "uidname")
      create(:project_owner, project_id: project.id,
                             user_id: owner.id)
      session[:user_id] = owner.id
      review1 = create(:review, content: "Looks good!")
      review2 = create(:review, content: "Huh?")
      create(:project_review, project_id: project.id,
                              review_id: review1.id)
      create(:project_review, project_id: project.id,
                              review_id: review2.id)
      rating1 = create(:rating, helpful: true)
      rating2 = create(:rating, helpful: false,
                                explanation: "Not helpful")
      create(:review_rating, review_id: review1.id,
                             rating_id: rating1.id)
      create(:review_rating, review_id: review2.id,
                             rating_id: rating2.id)

      get :show, params: { id: project.id }

      expect(response.body).to include(review1.content)
      expect(response.body).not_to include(review2.content)
    end

    it "includes a link to edit the project when logged in as the owner" do
      project = create(:project)
      owner = create(:user, name: "name",
                            email: "name@email.com",
                            uid: "uidname")
      create(:project_owner, project_id: project.id,
                             user_id: owner.id)
      session[:user_id] = owner.id

      get :show, params: { id: project.id }

      expect(response.body).to include("edit")
    end
  end

  describe "GET /projects/:id/edit" do
    it "redirects when not logged in" do
      project = create(:project)

      get :edit, params: { id: project.id }

      expect(response).to have_http_status(:redirect)
    end

    it "redirects when logged in as user who is not project owner" do
      project = create(:project)
      owner = create(:user, name: "name1",
                            email: "name1@email.com",
                            uid: "uidname1")
      user = create(:user, name: "name2",
                           email: "name2@email.com",
                           uid: "uidname2")
      create(:project_owner, project_id: project.id,
                             user_id: owner.id)
      session[:user_id] = user.id

      get :edit, params: { id: project.id }

      expect(response).to have_http_status(:redirect)
    end

    it "renders the template for the project edit page when logged in as the project owner" do
      project = create(:project)
      owner = create(:user)
      user = create(:user, email: "user@example.com")
      create(:project_owner, project_id: project.id,
                             user_id: owner.id)
      create(:project_invite, project_id: project.id,
                              user_id: user.id)
      session[:user_id] = owner.id

      get :edit, params: { id: project.id }

      expect(response).to have_http_status(200)
      expect(response.body).to include("Title")
      expect(response.body).to include(project.title)
      expect(response.body).to include("Description")
      expect(response.body).to include(project.description)
      expect(response.body).to include(user.email)
    end
  end

  describe "POST /projects/:id/edit" do
    it "edits the project and redirects to the index page with flash notice of changes" do
      project = create(:project)
      owner = create(:user, name: "name1", email: "owner@example.com")
      create(:project_owner, project_id: project.id,
                             user_id: owner.id)
      user = create(:user, name: "name2", email: "invitedreviewer@example.com")

      post :update, params: { id: project.id, 
                              project: { title: "best title", description: "best description" }, 
                              emails: [user.email] }

      updated_project = Project.find_by_id(project.id)
      expect(response).to redirect_to(project_path(project.id))
      expect(response).to have_http_status(:redirect)
      expect(updated_project.title).to eq("best title")
      expect(updated_project.description).to eq("best description")
      expect(updated_project.get_invited_reviewers).to include(user)
      expect(flash[:notice]).to match("Project has been updated")
    end

    it "removes an invited reviewer if deleted" do
      project = create(:project)
      user = create(:user, name: "name", email: "invitedreviewer@example.com")
      create(:project_invite, project_id: project.id,
                              user_id: user.id)

      post :update, params: { id: project.id, 
                              project: { title: "best title", description: "best description" }, 
                              emails: [] }

      updated_project = Project.find_by_id(project.id)
      expect(updated_project.get_invited_reviewers).not_to include(user)
    end

    it "displays flash error message if description is blank" do
      project = create(:project)

      post :update, params: { id: project.id, project: { title: "best title", description: "" } }

      expect(response).to redirect_to(edit_project_path(project.id))
      expect(flash[:error]).to match("Please provide a description")
    end

    it "displays flash error message if title is blank" do
      project = create(:project)

      post :update, params: { id: project.id, project: { title: "", description: "best description" } }

      expect(response).to redirect_to(edit_project_path(project.id))
      expect(flash[:error]).to match("Please provide a title")
    end
  end
end
