require "spec_helper"

describe "review", :type => :feature do

  describe "show page" do
    describe "when logged out" do
      it "redirects to root" do
        review = create(:review, content: "Looks good!")
        project = create(:project, title: "Foo", description: "Bar")
        create(:project_review, project_id: project.id,
                                review_id: review.id)

        visit "/reviews/" + review.id.to_s

        expect(current_path).to eq("/")
      end 
    end

    describe "when logged in as the project owner" do
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: "uidhillaryclinton",
                                   info: { name: "hillaryclinton",
                                           email: "hillaryclinton@gmail.com" } })
        @user = User.find_by(name: "hillaryclinton")
        reviewer = create(:user, name: "name1",
                                 email: "name1@email.com",
                                 uid: "uidname1")
        @review = create(:review, content: "Looks good!")
        project = create(:project, title: "Foo", description: "Bar")
        create(:project_owner, project_id: project.id,
                               user_id: @user.id)
        create(:project_review, project_id: project.id,
                                review_id: @review.id)
        create(:user_review, user_id: reviewer.id,
                             review_id: @review.id)

        visit "/"
        find_button("Sign in with Google").click
      end

      it "shows review content" do
        visit "/reviews/" + @review.id.to_s

        expect(page).to have_content(@review.content)
      end

      it "does not show link to edit review" do
        visit "/reviews/" + @review.id.to_s

        expect(page).not_to have_xpath("//i", :class => "fa fa-pencil-square-o")
      end

      it "does not show link to leave rating" do
        visit "/reviews/" + @review.id.to_s

        expect(page).not_to have_xpath("//i", :class => "fa fa-thumbs-up")
        expect(page).not_to have_xpath("//i", :class => "fa fa-thumbs-down")
        expect(page).not_to have_content("+ rate review")
      end
      

      it "does not show any ratings" do
        rating = create(:rating, helpful: true,
                                 explanation: "Great!")
        create(:review_rating, review_id: @review.id,
                               rating_id: rating.id)

        expect(page).not_to have_content(rating.explanation)
      end

      after(:each) do
        visit "/logout"
      end
    end

    describe "when logged in as a user who is not the reviewer or project owner" do
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: "uidhillaryclinton",
                                   info: { name: "hillaryclinton",
                                           email: "hillaryclinton@gmail.com" } })
        @user = User.find_by(name: "hillaryclinton")
        @review = create(:review, content: "Looks good!")
        project = create(:project, title: "Foo", description: "Bar")
        reviewer = create(:user, name: "name1",
                                 email: "name1@email.com",
                                 uid: "uidname1")
        owner = create(:user, name: "name2",
                              email: "name2@email.com",
                              uid: "uidname2")
        create(:project_owner, project_id: project.id,
                               user_id: owner.id)
        create(:project_review, project_id: project.id,
                                review_id: @review.id)
        create(:user_review, user_id: reviewer.id,
                             review_id: @review.id)

        visit "/"
        find_button("Sign in with Google").click
      end

      it "shows review content and link to leave rating" do
        visit "/reviews/" + @review.id.to_s

        expect(page).to have_content(@review.content)
        expect(page).to have_xpath("//i", :class => "fa fa-thumbs-up")
        expect(page).to have_link("back to project")
      end

      it "does not show link to edit review" do
        visit "/reviews/" + @review.id.to_s

        expect(page).not_to have_xpath("//i", :class => "fa fa-pencil-square-o")
      end

      it "does not show ratings left by other people" do
        rating = create(:rating, helpful: true,
                                 explanation: "Great!")
        rater = create(:user, name: "name3",
                              email: "name3@email.com",
                              uid: "uidname3")
        create(:review_rating, review_id: @review.id,
                               rating_id: rating.id)
        create(:user_rating, user_id: rater.id,
                             rating_id: rating.id)

        visit "/reviews/" + @review.id.to_s

        expect(page).not_to have_content(rating.explanation)
       end

     it "does show ratings left by logged in user" do
        rating = create(:rating, helpful: true,
                                 explanation: "Great!")
        create(:review_rating, review_id: @review.id,
                               rating_id: rating.id)
        create(:user_rating, user_id: @user.id,
                             rating_id: rating.id)

        visit "/reviews/" + @review.id.to_s

        expect(page).to have_content(rating.explanation)
      end

      it "loads new rating partial when thumbs up is clicked, with thumbs up preselected", :js => true do
        Capybara.ignore_hidden_elements = false

        visit "/reviews/" + @review.id.to_s
        find_by_id("new-rating-up").trigger("click")

        expect(page).to have_css("form")
        expect(page).to have_content("Rate review")
        expect(page).to have_checked_field("rating_helpful_true")
        expect(page).to have_button("Rate review")
      end

      it "loads new rating partial when thumbs down is clicked, with thumbs down preselected", :js => true do
        Capybara.ignore_hidden_elements = false

        visit "/reviews/" + @review.id.to_s
        find_by_id("new-rating-down").trigger("click")

        expect(page).to have_css("form")
        expect(page).to have_content("Rate review")
        expect(page).to have_checked_field("rating_helpful_false")
        expect(page).to have_button("Rate review")
      end

      after(:each) do
        visit "/logout"
      end
    end

    describe "when logged in as the reviewer" do
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: "uidhillaryclinton",
                                   info: { name: "hillaryclinton",
                                           email: "hillaryclinton@gmail.com" } })
        @reviewer = User.find_by(name: "hillaryclinton")
        @review = create(:review, content: "Looks good!")
        @project = create(:project, title: "Foo", description: "Bar")
        create(:project_review, project_id: @project.id,
                                review_id: @review.id)
        create(:user_review, user_id: @reviewer.id,
                             review_id: @review.id)

        visit "/"
        find_button("Sign in with Google").click
      end

      it "shows review content and all ratings for a review" do
        rating = create(:rating, helpful: true,
                                 explanation: "Great!")
        create(:review_rating, review_id: @review.id,
                               rating_id: rating.id)

        visit "/reviews/" + @review.id.to_s

        expect(page).to have_content(@review.content)
        expect(page).to have_content(rating.explanation)
        expect(page).to have_link("back to project")
      end

      it "does not show link to leave rating" do
        visit "/reviews/" + @review.id.to_s

        expect(page).not_to have_content("+ rate review")
        expect(page).not_to have_xpath("//i", :class => "fa fa-thumbs-up")
        expect(page).not_to have_xpath("//i", :class => "fa fa-thumbs-down")
      end
     
      it "shows all ratings in reverse chronological order" do
        rating1 = create(:rating, helpful: true, explanation: "Nice")
        rating2 = create(:rating, helpful: false, explanation: "Not specific")
        create(:review_rating, review_id: @review.id,
                               rating_id: rating1.id)
        create(:review_rating, review_id: @review.id,
                               rating_id: rating2.id)

        visit "/reviews/" + @review.id.to_s
        
        expect(page.body.index("Nice")).to be > page.body.index("Not specific")
      end

      it "loads partial to edit the review populated with the review content", :js => true do
        visit "/reviews/" + @review.id.to_s
        find_by_id("edit-review-link").trigger("click")

        expect(page).to have_content("Update review")
        expect(current_path).to eq("/reviews/" + @review.id.to_s)
      end

      it "navigates to the project page when the back link is clicked" do
        visit "/reviews/" + @review.id.to_s
        click_link("back to project")

        expect(page).to have_content(@project.title)
        expect(current_path).to eq("/projects/" + @project.id.to_s)
      end

      it "allows deletion of review when review has not yet been rated" do
        review = create(:review, content: "Looks good!")
        create(:project_review, project_id: @project.id,
                                review_id: review.id)
        create(:user_review, user_id: @reviewer.id,
                             review_id: review.id)

        visit "/reviews/" + review.id.to_s
        click_link("delete-review-link")

        expect(current_path).to eq("/users/" + @reviewer.id.to_s)
      end
      
      it "does not show the link to delete when review has been rated" do 
        rating = create(:rating, helpful: true)
        create(:review_rating, review_id: @review.id,
                               rating_id: rating.id)

        visit "/reviews/" + @review.id.to_s

        expect(page).not_to have_xpath("//i", :class => "fa fa-times")
      end

      after(:each) do
        visit "/logout"
      end
    end
  end

  describe "new page" do
    describe "when logged out" do
       it "redirects to root" do
        project = create(:project, title: "Foo", description: "Bar")

        visit "/reviews/new/" + project.id.to_s

        expect(current_path).to eq("/")
      end 
    end
    
    describe "when logged in as a user who is invited to review" do 
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: "uidhillaryclinton",
                                   info: { name: "hillaryclinton",
                                           email: "hillaryclinton@gmail.com" } })
        @invite = User.find_by(name: "hillaryclinton")
        @project = create(:project, title: "Foo", description: "Bar")
        create(:project_invite, project_id: @project.id,
                                user_id: @invite.id)

        visit "/"
        find_button("Sign in with Google").click
      end

     it "redirects to the project show page when a review is submitted" do
        visit "/projects/" + @project.id.to_s
        click_link("+ review project")
        fill_in("review[content]", with: "my review")
        click_button("Create new review")

        expect(current_path).to eq("/projects/" + @project.id.to_s)
        expect(page).to have_content("my review")
        expect(page).to have_content("Review has been created")
      end

      it "displays a warning if content is left blank when creating a new review", :js => true do
        visit "/projects/" + @project.id.to_s
        click_link("+ review project")
        click_button("Create new review")

        expect(page).to have_content("Create new review")
        expect(page).to have_content("Review cannot be blank")
        expect(current_path).to eq("/projects/" + @project.id.to_s)
      end

      it "redirects back to the project show page when cancel link is clicked", :js => true do
        visit "/projects/" + @project.id.to_s
        click_link("+ review project")
        click_link("cancel")

        expect(current_path).to eq("/projects/" + @project.id.to_s)
        expect(page).to have_no_css("form")
      end

      after(:each) do
        visit "/logout"
      end
    end

    describe "when logged in as a user who has not been invited to review" do
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: "uidhillaryclinton",
                                   info: { name: "hillaryclinton",
                                           email: "hillaryclinton@gmail.com" } })
        @user = User.find_by(name: "hillaryclinton")
        @project = create(:project, title: "Foo", description: "Bar")

        visit "/"
        find_button("Sign in with Google").click
      end

      it "redirects to user show page" do
        visit "/reviews/new/" + @project.id.to_s

        expect(current_path).to eq("/users/" + @user.id.to_s)
      end

      after(:each) do
        visit "/logout"
      end
    end
  end

  describe "edit page" do
    describe "when logged out" do
      it "redirects to root" do
        review = create(:review, content: "Looks good!")
        project = create(:project, title: "Foo", description: "Bar")
        create(:project_review, project_id: project.id,
                                review_id: review.id)

        visit "/reviews/" + review.id.to_s + "/edit"

        expect(current_path).to eq("/")
      end
    end

    describe "when logged in as a user who is not the reviewer" do
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: "uidhillaryclinton",
                                   info: { name: "hillaryclinton",
                                           email: "hillaryclinton@gmail.com" } })
        @user = User.find_by(name: "hillaryclinton")
        reviewer = create(:user, name: "name1",
                                 email: "name1@email.com",
                                 uid: "uidname1")
        project = create(:project, title: "Foo", description: "Bar")
        @review = create(:review, content: "Looks good!")
        create(:project_review, project_id: project.id,
                                review_id: @review.id)
        create(:user_review, user_id: reviewer.id,
                             review_id: @review.id)

        visit "/"
        find_button("Sign in with Google").click
      end

      it "redirects to user show page" do
        visit "/reviews/" + @review.id.to_s + "/edit"

        expect(current_path).to eq("/users/" + @user.id.to_s)
      end

      after(:each) do
        visit "/logout"
      end
    end

    describe "when logged in as reviewer" do
      before(:each) do
        OmniAuth.config.add_mock(:google_oauth2,
                                 { uid: "uidhillaryclinton",
                                   info: { name: "hillaryclinton",
                                           email: "hillaryclinton@gmail.com" } })
        @reviewer = User.find_by(name: "hillaryclinton")
        @review = create(:review, content: "Stupendous!")
        project = create(:project, title: "Foo", description: "Bar")
        create(:project_review, project_id: project.id,
                                review_id: @review.id)
        create(:user_review, user_id: @reviewer.id,
                             review_id: @review.id)

        visit "/"
        find_button("Sign in with Google").click
      end

      it "reloads the review show page when a review is edited" do
        visit "/reviews/" + @review.id.to_s
        click_link("edit-review-link")
        fill_in("review[content]", with: "FUBAR")
        click_button("Update review")

        expect(current_path).to eq("/reviews/" + @review.id.to_s)
        expect(page).to have_content("Review has been updated")
        expect(page).to have_content("FUBAR")
        expect(page).not_to have_content("Stupendous!")
      end

     it "displays a warning if content is left blank when editing a new review", :js => true do
        visit "/reviews/" + @review.id.to_s
        find_by_id("edit-review-link").trigger("click")
        fill_in("review[content]", with: "")
        click_button("Update review")

        expect(page).to have_content("Review cannot be blank")
        expect(current_path).to eq("/reviews/" + @review.id.to_s)
      end

      it "redirects back to review show page when cancel link is clicked", :js => true do
        visit "/reviews/" + @review.id.to_s
        find_by_id("edit-review-link").trigger("click")
        click_link("cancel")

        expect(current_path).to eq("/reviews/" + @review.id.to_s)
        expect(page).to have_no_css("form")
        expect(page).to have_content("Stupendous!")
      end


      after(:each) do
        visit "/logout"
      end
    end
  end
end
