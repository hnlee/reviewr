require "spec_helper"

describe "user", :type => :feature do
  
  before(:all) do 
    DatabaseCleaner.strategy = :truncation
  end

  after(:all) do 
    DatabaseCleaner.clean
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end 

  describe "logged out index page" do
    it "has a link to Google authentication" do 
      visit "/"

      expect(page).to have_button("Sign in with Google")
    end
  end

  describe "logged in index page" do
    it "has a link to log out" do
      OmniAuth.config.add_mock(:google_oauth2,
                               { uid: "uidhillaryclinton",
                                 info: { name: "hillaryclinton",
                                         email: "hillaryclinton@gmail.com" } })

      visit "/"
      find_button("Sign in with Google").click

      expect(page).to have_link("Sign out")
    end
  end

  describe "show page" do
    before(:each) do
      OmniAuth.config.add_mock(:google_oauth2,
                               { uid: "uidhillaryclinton",
                                 info: { name: "hillaryclinton",
                                         email: "hillaryclinton@gmail.com" } })
      @user = User.find_by_name("hillaryclinton")

      visit "/"
      find_button("Sign in with Google").click
    end

    describe "scores" do
      it "shows the scores if user has left at least three ratings" do
        3.times do |i|
          rating = create(:rating, helpful: true)  
          create(:user_rating, rating_id: rating.id,
                               user_id: @user.id)
        end
        review = create(:review)
        create(:user_review, user_id: @user.id,
                           review_id: review.id)
        3.times do |i|
          rating = create(:rating, helpful: true)
          create(:review_rating, review_id: review.id,
                                 rating_id: rating.id)
        end
        2.times do |i|
          rating = create(:rating, helpful: false,
                                   explanation: "Not helpful")
          create(:review_rating, review_id: review.id,
                                 rating_id: rating.id)
        end

        visit user_path(id: @user)

        expect(page).to have_content(@user.get_scores[:helpful])
        expect(page).to have_content(@user.get_scores[:unhelpful])
      end

      it "does not show scores if user has not left three ratings" do
        @user.ratings.each do |rating|
          ReviewRating.destroy(ReviewRating.where(rating_id: rating).ids)
          UserRating.destroy(UserRating.where(rating_id: rating).ids)
          Rating.destroy(rating.id)
        end
        review = create(:review)
        create(:user_review, user_id: @user.id,
                           review_id: review.id)
        3.times do |i|
          rating = create(:rating, helpful: true)
          create(:review_rating, review_id: review.id,
                                 rating_id: rating.id)
        end
        2.times do |i|
          rating = create(:rating, helpful: false,
                                   explanation: "Not helpful")
          create(:review_rating, review_id: review.id,
                                 rating_id: rating.id)
        end         

        visit user_path(id: @user)

        expect(page).to have_content("Rate 3 reviews to see your scores")
      end
    end

    describe "projects tab" do
      it "shows projects that belong to the user" do
        project1 = create(:project, title: "Rust Http Server")
        project2 = create(:project, title: "Java Tic-Tac-Toe")
        create(:project_owner, project_id: project1.id,
                               user_id: @user.id)
        create(:project_owner, project_id: project2.id,
                               user_id: @user.id)

        visit user_path(id: @user)

        expect(page).to have_content(project1.title)
        expect(page).to have_content(project2.title)
      end

      it "does not show projects that do not belong to the user" do
        user = create(:user, name: "name1", 
                             email: "name1@example.com",
                             uid: "uidname1")
        project = create(:project, title: "Ruby Game of Life")
        create(:project_owner, project_id: project.id,
                               user_id: user.id)

        visit user_path(id: @user)

        expect(page).to have_no_content("Ruby Game of Life")
      end

      it "shows all projects as links" do
        project1 = create(:project, title: "Rust Http Server")
        project2 = create(:project, title: "Java Tic-Tac-Toe")
        create(:project_owner, project_id: project1.id,
                               user_id: @user.id)
        create(:project_owner, project_id: project2.id,
                               user_id: @user.id)

        visit user_path(id: @user)

        expect(page).to have_link(project1.title)
        expect(page).to have_link(project2.title)
      end

      it "navigates to project show page when project title is clicked" do
        project = create(:project, title: "Elm Coin Changer")
        create(:project_owner, project_id: project.id,
                               user_id: @user.id)
        
        visit user_path(id: @user)
        click_link("Elm Coin Changer")

        expect(current_path).to eq("/projects/" + project.id.to_s)
      end

      it "navigates to new project page when new project link is clicked" do
        visit user_path(id: @user)
        click_link("+ create new project")

        expect(page).to have_css("form")
        expect(current_path).to eq("/projects/new")
      end

      it "shows projects in reverse chronological order" do
        project1 = create(:project, title: "Rust Http Server")
        project2 = create(:project, title: "Java Tic-Tac-Toe")
        create(:project_owner, project_id: project1.id,
                               user_id: @user.id)
        create(:project_owner, project_id: project2.id,
                               user_id: @user.id)

        expect(page.body.index(project1.title)).to be > page.body.index(project2.title)
      end
    end

    describe "reviews tab" do
      it "shows reviews that belong to the user" do
        review1 = create(:review, content: "Looks great")
        review2 = create(:review, content: "Looks terrible")
        create(:user_review, user_id: @user.id,
                             review_id: review1.id)
        create(:user_review, user_id: @user.id,
                             review_id: review2.id)

        visit user_path(id: @user)

        expect(page).to have_content(review1.content)
        expect(page).to have_content(review2.content)
      end

      it "does not show reviews that do not belong to the user" do
        user = create(:user, name: "name1", 
                             email: "name1@example.com",
                             uid: "uidname1")
        review = create(:review, content: "Fantabulous")
        create(:user_review, review_id: review.id,
                             user_id: user.id)

        visit user_path(id: @user)

        expect(find_by_id('reviews')).not_to have_content(review.content)
      end

      it "shows all reviews as links" do
        review1 = create(:review, content: "Great job")
        review2 = create(:review, content: "Awful job")
        create(:user_review, user_id: @user.id,
                             review_id: review1.id)
        create(:user_review, user_id: @user.id,
                             review_id: review2.id)

        visit user_path(id: @user)

        expect(page).to have_link(review1.content)
        expect(page).to have_link(review2.content)
      end

      it "navigates to review show page when review content is clicked" do
        review = create(:review, content: "You did good, kid")
        project = create(:project, title: "Clojure Roman Numerals")
        create(:user_review, user_id: @user.id,
                             review_id: review.id)
        create(:project_review, project_id: project.id,
                                review_id: review.id) 

        visit user_path(id: @user)
        click_link("You did good, kid")

        expect(current_path).to eq("/reviews/" + review.id.to_s)
      end

      it "shows reviews in reverse chronological order" do
        review1 = create(:review, content: "Stupendous job")
        review2 = create(:review, content: "Atrocious job")
        create(:user_review, user_id: @user.id,
                             review_id: review1.id)
        create(:user_review, user_id: @user.id,
                             review_id: review2.id)

        visit user_path(id: @user)

        expect(page.body.index(review1.content)).to be > page.body.index(review2.content)
      end
    end

    describe "pending reviews tab" do 
      it "shows projects for which the user has been invited to review" do
        project = create(:project, title: "Java Bowling Game")
        create(:project_invite, project_id: project.id,
                                user_id: @user.id)

        visit user_path(id: @user)
        
        expect(page).to have_link(project.title)
      end
    end

    describe "random review div" do
      it "shows a random review to be rated" do
        visit user_path(id: @user)

        expect(page).to have_content("Rate This Review")
      end

      it "shows new rating form when thumbs up is clicked", :js => true do
        Capybara.ignore_hidden_elements = false
        visit user_path(id: @user)
        find_by_id("random-rating-up").trigger("click")

        expect(page).to have_css("form")
        expect(page).to have_checked_field("rating_helpful_true")
        expect(page).to have_button("Rate review")
      end

      it "shows new rating form when thumbs down is clicked", :js => true do
        Capybara.ignore_hidden_elements = false
        visit user_path(id: @user)

        find_by_id("random-rating-down").trigger("click")

        expect(page).to have_css("form")
        expect(page).to have_checked_field("rating_helpful_false")
        expect(page).to have_button("Rate review")
      end
    end

  end
end
