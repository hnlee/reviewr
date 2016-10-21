class ReviewRating < ApplicationRecord
  belongs_to :review
  belongs_to :rating
end
