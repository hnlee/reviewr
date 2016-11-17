require "rails_helper"

RSpec.describe Rating do
  describe "validations" do
    it "has helpful boolean set" do
      rating = Rating.new(helpful: true)

      expect(rating.helpful).to eq(true)
    end

    it "does not save if helpful field is not set" do
      rating = Rating.create(helpful: nil)

      expect(rating.id).to eq(nil)
    end

    it "has an explanation field that can be set" do
      explanation = "This review is not kind, specific, or actionable."
      rating = Rating.new(helpful: false,
                          explanation: explanation)

      expect(rating.explanation).to eq(explanation)
    end

    it "does not save if helpful is false and explanation is blank" do
      rating = Rating.create(helpful: false,
                             explanation: "")

      expect(rating.id).to eq(nil)
    end
  end

  describe "attributes" do
    it "has one user who gave the rating" do
      rating = Rating.create(helpful: true)
      user = create(:user)
      create(:user_rating, user_id: user.id,
                           rating_id: rating.id)

      expect(rating.user).to eq(user)
    end

    it "has one review to which it belongs" do
      rating = Rating.create(helpful: true)
      review = Review.create(content: "review content")
      create(:review_rating, review_id: review.id,
                             rating_id: rating.id)

      expect(rating.review).to eq(review)
    end
  end

  describe "#unhelpful?" do
    it "returns true if helpful is set to false" do
      rating = Rating.create(helpful: false,
                             explanation: "bad")

      expect(rating.unhelpful?).to eq(true)
    end

    it "returns false if helpful is set to true" do
      rating = Rating.create(helpful: true)

      expect(rating.unhelpful?).to eq(false)
    end
  end

  describe ".get_user_owned_ratings" do
    it "returns the ratings created by the user for the review" do
      rating = Rating.create(helpful: true)
      review = create(:review)
      create(:review_rating, review_id: review.id,
                             rating_id: rating.id)
      user = create(:user)
      create(:user_rating, user_id: user.id,
                           rating_id: rating.id)

      expect(Rating.get_user_owned_ratings(user, review)).to include(rating)
    end

    it "does not return ratings created by other users" do
      rating = Rating.create(helpful: true)
      review = create(:review)
      create(:review_rating, review_id: review.id,
                             rating_id: rating.id)
      user1 = create(:user)
      user2 = create(:user)
      create(:user_rating, user_id: user2.id,
                           rating_id: rating.id)

      expect(Rating.get_user_owned_ratings(user1, review)).not_to include(rating)
    end

    it "does not return ratings created by the user for other reviews" do
      rating = Rating.create(helpful: true)
      review1 = create(:review)
      review2 = create(:review)
      create(:review_rating, review_id: review2.id,
                             rating_id: rating.id)
      user = create(:user)
      create(:user_rating, user_id: user.id,
                           rating_id: rating.id)

      expect(Rating.get_user_owned_ratings(user, review1)).not_to include(rating)
    end
  end
end
