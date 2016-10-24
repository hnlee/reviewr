class Rating < ApplicationRecord
  has_one :review_rating
  has_one :review, through: :review_rating
end
