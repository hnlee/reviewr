class User < ApplicationRecord
  has_many :project_owners
  has_many :projects, through: :project_owners

  has_many :project_invites
  has_many :invites, through: :project_invites, source: :project

  has_many :user_reviews
  has_many :reviews, through: :user_reviews

  has_many :user_ratings
  has_many :ratings, through: :user_ratings
end
