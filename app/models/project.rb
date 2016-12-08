class Project < ApplicationRecord
  validates :title, :link, :description, presence: true

  has_many :project_reviews
  has_many :reviews, through: :project_reviews

  has_one :project_owner
  has_one :owner, through: :project_owner, source: :user

  has_many :project_invites
  has_many :invites, through: :project_invites, source: :user

  def get_error_message
    missing = []
    if title.blank? 
      missing.push("title")
    end
    if link.blank?
      missing.push("link")
    end
    if description.blank?
      missing.push("description")
    end
    if missing.count > 1
      missing.insert(-2, "and")
    end
    if missing.count > 3
      missing[0] += ","
    end
    return "Please provide a " + missing.join(" ")
  end

  def helpful_reviews_count
    reviews.select{ |r| r.visible? }.count
  end

  def get_reviewers
    user_reviews = UserReview.where(review_id: reviews)
                             .select("user_id")
    return User.where(id: user_reviews).all
  end

  def get_invited_reviewers
    project_invites = ProjectInvite.where(project_id: id)
                                   .select("user_id")
    return User.where(id: project_invites).all
  end
end
