class Review < ApplicationRecord
  validates :content, presence: true

  has_one :project_review
  has_one :project, through: :project_review

  has_many :review_ratings
  has_many :ratings, through: :review_ratings
  
  has_one :user_review
  has_one :user, through: :user_review

  def visible?
    positive = self.ratings.select { |rating| rating.helpful == true }
    negative = self.ratings.select { |rating| rating.helpful == false }
    if positive.count > 0 and negative.count == 0
      return true
    else
      return false
    end
  end

  def get_project
    if project
      return project.title
    end
  end

  def get_project_owner
    if project and project.project_owner
      return project.project_owner.user.name
    end
  end

  def self.get_random_review(user)
    user_reviews = user.reviews
    reviews = Review.where.not(id: user_reviews).all
    reviews.offset(rand(reviews.count)).first
  end
end
