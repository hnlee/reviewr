class Project < ApplicationRecord
  validates :title, :description, presence: true

  has_many :project_reviews
  has_many :reviews, through: :project_reviews

end
