class Rating < ApplicationRecord
  validates :helpful, inclusion: { in: [true, false] }
  validates :explanation, presence: true, if: :unhelpful?

  has_one :review_rating
  has_one :review, through: :review_rating

  def unhelpful?
    helpful == false
  end

end
