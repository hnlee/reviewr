class RatingCheck < ApplicationRecord
  validates :category, presence: true
  validates :value, inclusion: { in: [true, false] }

  belongs_to :rating
end
