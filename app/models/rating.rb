class Rating < ApplicationRecord
  has_many :rating_checks
  belongs_to :review
end
