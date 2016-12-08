class Rating < ApplicationRecord
  validates :helpful, inclusion: { in: [true, false] }
  validates :explanation, presence: true, if: :unhelpful?

  has_one :review_rating
  has_one :review, through: :review_rating

  has_one :user_rating
  has_one :user, through: :user_rating

  def unhelpful?
    helpful == false
  end

  def self.get_user_owned_ratings(user, review)
    return Rating.where(id: review.ratings)
                 .where(id: user.ratings)
                 .all.order(updated_at: :desc)
  end
end
