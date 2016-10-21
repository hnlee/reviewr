class Review < ApplicationRecord
  validates :content, presence: true

  has_one :project_review
  has_one :project, through: :project_review
end
