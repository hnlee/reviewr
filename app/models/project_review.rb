class ProjectReview < ApplicationRecord
  belongs_to :project
  belongs_to :review
end
