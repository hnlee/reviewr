class User < ApplicationRecord
  validates :email, presence: true
  
  has_many :project_owners
  has_many :projects, through: :project_owners

  has_many :project_invites
  has_many :invites, through: :project_invites, source: :project

  has_many :user_reviews
  has_many :reviews, through: :user_reviews

  has_many :user_ratings
  has_many :ratings, through: :user_ratings

  def self.from_omniauth(auth_hash)
    user = find_or_create_by(uid: auth_hash[:uid])
    user.name = auth_hash[:info][:name]
    user.email = auth_hash[:info][:email]
    user.save
    user
  end

  def get_open_invites
    invites.select{ |project| !project.get_reviewers.include? self }
  end
end
