class Project < ApplicationRecord
  validates :title, :description, presence: true

end
