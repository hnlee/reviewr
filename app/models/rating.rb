class Rating < ApplicationRecord
  validates :helpful, inclusion: { in: [true, false] }

  has_one :review_rating
  has_one :review, through: :review_rating
end
