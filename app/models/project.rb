class Project < ApplicationRecord
  validates :title, :description, presence: true

  has_many :project_reviews
  has_many :reviews, through: :project_reviews

  has_one :project_owner
  has_one :owner, through: :project_owner, source: :user

  has_many :project_invites
  has_many :invites, through: :project_invites, source: :user
end
