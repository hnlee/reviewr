class Review < ApplicationRecord
  validates :content, presence: true

  has_one :project_review
  has_one :project, through: :project_review

  has_many :review_ratings
  has_many :ratings, through: :review_ratings
end
