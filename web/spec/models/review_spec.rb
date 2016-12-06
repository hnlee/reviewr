require "rails_helper"

RSpec.describe Review do
  describe "attributes" do
    it "has content" do
      review = Review.new(content: "Looks good!")

      expect(review.content).to eq("Looks good!")
    end

    it "has many ratings" do
      review = Review.create(content: "Amazing")
      rating1 = create(:rating, helpful: true)
      rating2 = create(:rating, helpful: false,
                                explanation: "not specific")
      create(:review_rating, review_id: review.id,
                             rating_id: rating1.id)
      create(:review_rating, review_id: review.id,
                             rating_id: rating2.id)

      expect(review.ratings.length).to eq(2)
    end

    it "has one user who wrote the review" do
      review = Review.create(content: "Terrible")
      user = create(:user, name: "Sally",
                           email: "sally@email.com")
      create(:user_review, user_id: user.id,
                           review_id: review.id)

      expect(review.user).to eq(user)
    end
  end

  describe "#visible?" do
    it "returns true if the review has at least one rating and all ratings are positive" do
      review = Review.create(content: "Looks good")
      rating_good = Rating.create(helpful: true)
      ReviewRating.create(review_id: review.id, rating_id: rating_good.id)

      expect(review.visible?).to eq(true)
    end

    it "returns false if the review has no ratings" do
      review = Review.create(content: "Looks good")

      expect(review.visible?).to eq(false)
    end

    it "returns false if the review has at least one negative rating" do
      review = Review.create(content: "Looks good")
      rating_good = Rating.create(helpful: true)
      rating_bad = Rating.create(helpful: false)
      ReviewRating.create(review_id: review.id, rating_id: rating_good.id)
      ReviewRating.create(review_id: review.id, rating_id: rating_bad.id)

      expect(review.visible?).to eq(true)
    end
  end

  describe "#get_project" do
    it "returns the project title" do
      review = create(:review)
      project = create(:project, title: "Blog post about stuff")
      create(:project_review, project_id: project.id, review_id: review.id)

      expect(review.get_project).to eq(project.title)
    end
  end

  describe "#get_project_owner" do
    it "returns the project owner name" do
      review = create(:review)
      project = create(:project)
      user = create(:user, name: "Bob")
      create(:project_review, project_id: project.id, review_id: review.id)
      create(:project_owner, project_id: project.id, user_id: user.id)

      expect(review.get_project_owner).to eq("Bob")
    end
  end

  describe ".get_random_review" do
    it "returns a random review" do
      user = create(:user, email: "random@email.com")
      review1 = create(:review)
      review2 = create(:review)
      review3 = create(:review)
      reviews = [review1, review2, review3]

      random_review = Review.get_random_review(user)

      expect(reviews).to include(random_review)
    end

    it "does not return a random review if it belongs to the user" do
      user = User.create(name: "Bob", email: "bob@email.com")
      review1 = Review.create(content: "1")
      review2 = Review.create(content: "2")
      UserReview.create(user_id: user.id, review_id: review1.id)

      random_review = Review.get_random_review(user)

      expect(random_review).not_to eq(review1)
    end
  end

  describe ".get_user_owned_reviews" do
    it "returns the reviews created by the user for the project" do
      review = Review.create(content: "Great work")
      project = create(:project)
      create(:project_review, review_id: review.id,
                              project_id: project.id)
      user = create(:user, email: "user@email.com")
      create(:user_review, user_id: user.id,
                           review_id: review.id)

      expect(Review.get_user_owned_reviews(user, project)).to include(review)
    end

    it "does not return reviews created by other users" do
      review = Review.create(content: "Great work")
      project = create(:project)
      create(:project_review, review_id: review.id,
                              project_id: project.id)
      user1 = create(:user, email: "user1@email.com")
      user2 = create(:user, email: "user2@email.com")
      create(:user_review, user_id: user2.id,
                           review_id: review.id)

      expect(Review.get_user_owned_reviews(user1, project)).not_to include(review)
    end

    it "does not return reviews created by the user for other projects" do
      review = Review.create(content: "Great work")
      project1 = create(:project)
      project2 = create(:project)
      create(:project_review, review_id: review.id,
                              project_id: project2.id)
      user = create(:user, email: "user@email.com")
      create(:user_review, user_id: user.id,
                           review_id: review.id)

      expect(Review.get_user_owned_reviews(user, project1)).not_to include(review)
    end
  end
end
