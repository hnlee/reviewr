require "spec_helper"

describe "rating", :type => :feature do
  describe "new page" do
   before(:each) do
      OmniAuth.config.add_mock(:google_oauth2,
                               { uid: "uidhillaryclinton",
                                 info: { name: "hillaryclinton",
                                         email: "hillaryclinton@gmail.com" } })
      @user = User.find_by_name("hillaryclinton")
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

    it "redirects to the review show page when a rating is submitted", :js => true do
      visit "/reviews/" + @review.id.to_s
      find_by_id("new-rating-up").trigger("click")
      click_button("Rate review")

      expect(page).to have_xpath("//i", :class => "fa fa-thumbs-up")
      expect(current_path).to eq("/reviews/" + @review.id.to_s)
    end

    it "displays error message on page if rated not helpful without any explanation", :js => true do
      visit "/reviews/" + @review.id.to_s
      find_by_id("new-rating-down").trigger("click")
      click_button("Rate review")

      expect(current_path).to eq("/reviews/" + @review.id.to_s)
      expect(page).to have_content("Please provide an explanation")
    end

    it "creates new rating if rated not helpful and explanation provided", :js => true do
      explanation = "Need to be more specific"

      visit "/reviews/" + @review.id.to_s
      find_by_id("new-rating-down").trigger("click")
      fill_in("rating_explanation", :with => explanation)
      click_button("Rate review")

      expect(page).to have_xpath("//i", :class => "fa fa-thumbs-down")
      expect(page).to have_content(explanation)
    end
    
    it "redirects to the review show page if cancel link is hit", :js => true do
      visit "/reviews/" + @review.id.to_s
      find_by_id("new-rating-down").trigger("click")
      click_link("cancel")

      expect(current_path).to eq("/reviews/" + @review.id.to_s)
      expect(page).to have_no_css("form") 
    end

    after(:each) do
      visit "/logout"
    end
  end

  describe "random new page" do
    before(:each) do
      OmniAuth.config.add_mock(:google_oauth2,
                               { uid: "uidhillaryclinton",
                                 info: { name: "hillaryclinton",
                                         email: "hillaryclinton@gmail.com" } })
      @user = User.find_by_name("hillaryclinton")

      visit "/"
      find_button("Sign in with Google").click
    end

    it "redirects to the index from the rating form is cancel is hit", :js => true do
      Capybara.ignore_hidden_elements = false

      visit user_path(id: @user.id)
      find_by_id("random-rating-up").trigger("click")
      click_link("cancel")

      expect(current_path).to eq("/users/" + @user.id.to_s)
      expect(page).to have_no_css("form")
    end

    it "redirects to the user show page from the rating form when a new rating is submitted", :js => true do
      Capybara.ignore_hidden_elements = false
      
      visit user_path(id: @user.id)
      find_by_id("random-rating-up").trigger("click")
      find_by_id("submit-rating-button").trigger("click")

      expect(current_path).to eq("/users/" + @user.id.to_s)
    end

    it "displays error message from the rating form if rated not helpful without any explanation", :js => true do
      Capybara.ignore_hidden_elements = false

      visit user_path(id: @user.id)
      find_by_id("random-rating-down").trigger("click")
      find_by_id("submit-rating-button").trigger("click")

      expect(current_path).to eq("/users/" + @user.id.to_s)
      expect(page).to have_content("Please provide an explanation")
    end

    after(:each) do
      visit "/logout"
    end
  end
end
