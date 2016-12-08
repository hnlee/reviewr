require "rails_helper"

RSpec.describe Project do
  describe "attributes" do
    it "has a title and description" do
      project = Project.new(title: "My Title",
                            link: "http://link.link",
                            description: "My Description")

      expect(project.title).to eq("My Title")
      expect(project.link).to eq("http://link.link")
      expect(project.description).to eq("My Description")
    end

    it "has many reviews" do
      project = Project.create(title: "My Title",
                               link: "http://link.link",
                               description: "My Description")
      review1 = create(:review, content: "Content1")
      review2 = create(:review, content: "Content2")
      review3 = create(:review, content: "Content3")
      create(:project_review, project_id: project.id,
                              review_id: review1.id)
      create(:project_review, project_id: project.id,
                              review_id: review2.id)
      create(:project_review, project_id: project.id,
                              review_id: review3.id)

      expect(project.reviews.length).to eq(3)
    end

    it "has an owner" do
      project = Project.create(title: "My Title",
                               link: "http://link.link",
                               description: "My Description")
      owner = create(:user, name: "Sally",
                            email: "sally@email.com")
      create(:project_owner, project_id: project.id,
                             user_id: owner.id)

      expect(project.owner).to eq(owner)
    end

    it "has many users invited to review" do
      project = Project.create(title: "My Title",
                               link: "http://link.link",
                               description: "My Description")
      invite1 = create(:user, name: "Sally",
                              email: "sally@email.com")
      invite2 = create(:user, name: "Molly",
                              email: "molly@email.com")
      invite3 = create(:user, name: "Polly",
                              email: "polly@email.com")
      create(:project_invite, project_id: project.id,
                              user_id: invite1.id)
      create(:project_invite, project_id: project.id,
                              user_id: invite2.id)
      create(:project_invite, project_id: project.id,
                              user_id: invite3.id)

      expect(project.invites.length).to eq(3)
    end
  end

  describe "#get_error_message" do
    it "returns message requesting title if it is omitted" do
      project = Project.create(link: "http://link.link",
                               description: "A description for the ages")

      expect(project.get_error_message).to eq("Please provide a title")
    end

    it "returns message requesting description if it is omitted" do
      project = Project.create(title: "A title for the ages",
                               link: "http://link.link")

      expect(project.get_error_message).to eq("Please provide a description")
    end

    it "returns message requesting title and description if both are omitted" do
      project = Project.create(title: "", 
                               link: "http://link.link",
                               description: "")

      expect(project.get_error_message).to eq("Please provide a title and description")
    end

    it "returns message requesting title and link if both are omitted" do
      project = Project.create(title: "", 
                               link: "",
                               description: "My Description")

      expect(project.get_error_message).to eq("Please provide a title and link")
    end

    it "returns message requesting link and description if both are omitted" do
      project = Project.create(title: "My Title", 
                               link: "",
                               description: "")

      expect(project.get_error_message).to eq("Please provide a link and description")
    end

    it "returns message requesting title, link and description if all are omitted" do
      project = Project.create(title: "", 
                               link: "",
                               description: "")

      expect(project.get_error_message).to eq("Please provide a title, link and description")
    end
  end

  describe "#helpful_reviews_count" do
    it "returns the number of reviews that are helpful" do
      project = Project.create(title: "My Title",
                               link: "http://link.link",
                               description: "My Description")
      review1 = create(:review, content: "Looks good")
      review2 = create(:review, content: "Looks bad")
      review3 = create(:review, content: "Looks great")
      rating_good = create(:rating, helpful: true)
      rating_bad = create(:rating, helpful: false,
                                   explanation: "bad")
      create(:project_review, project_id: project.id,
                              review_id: review1.id)
      create(:project_review, project_id: project.id,
                              review_id: review2.id)
      create(:project_review, project_id: project.id,
                              review_id: review3.id)
      create(:review_rating, review_id: review1.id,
                             rating_id: rating_good.id)
      create(:review_rating, review_id: review2.id,
                             rating_id: rating_bad.id)
      create(:review_rating, review_id: review3.id,
                             rating_id: rating_good.id)

      expect(project.helpful_reviews_count).to eq(2)
    end
  end

  describe "#get_reviewers" do
    it "returns the users who have reviewed the project" do
      project = Project.create(title: "My Title",
                               link: "http://link.link",
                               description: "My Description")
      review1 = create(:review, content: "Looks good")
      review2 = create(:review, content: "Looks bad")
      review3 = create(:review, content: "Looks great")
      user1 = create(:user, name: "name1",
                            email: "name1@email.com",
                            uid: "uidname1")
      user2 = create(:user, name: "name2",
                            email: "name2@email.com",
                            uid: "uidname2")
      user3 = create(:user, name: "name3",
                            email: "name3@email.com",
                            uid: "uidname3")
      create(:project_review, project_id: project.id,
                              review_id: review1.id)
      create(:project_review, project_id: project.id,
                              review_id: review2.id)
      create(:project_review, project_id: project.id,
                              review_id: review3.id)
      create(:user_review, user_id: user1.id,
                           review_id: review1.id)
      create(:user_review, user_id: user2.id,
                           review_id: review2.id)
      create(:user_review, user_id: user3.id,
                           review_id: review3.id)

      expect(project.get_reviewers).to include(user1)
      expect(project.get_reviewers).to include(user2)
      expect(project.get_reviewers).to include(user3)
    end
  end
end
