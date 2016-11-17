class Project < ApplicationRecord
  validates :title, :description, presence: true

  has_many :project_reviews
  has_many :reviews, through: :project_reviews

  has_one :project_owner
  has_one :owner, through: :project_owner, source: :user

  has_many :project_invites
  has_many :invites, through: :project_invites, source: :user

  def get_error_message
    if title.blank? and description.blank?
      return "Please provide a title and description"
    elsif description.blank?
      return "Please provide a description"
    else
      return "Please provide a title"
    end
  end

  def helpful_reviews_count
    reviews.select{ |r| r.visible? }.count
  end

  def get_reviewers
    user_reviews = UserReview.where(review_id: reviews)
                             .select('user_id')
    return User.where(id: user_reviews).all
  end

  def get_invited_reviewers
    project_invites = ProjectInvite.where(project_id: id)
                                   .select('user_id')
    return User.where(id: project_invites).all
  end
end
