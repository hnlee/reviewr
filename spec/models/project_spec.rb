require 'rails_helper'

RSpec.describe Project do
  describe 'attributes' do
    it 'has a title and description' do
      project = Project.new(title: "My Title",
                            description: "My Description")

      expect(project.title).to eq("My Title")
      expect(project.description).to eq("My Description")
    end

    it 'has many reviews' do
      project = Project.create(title: "My Title",
                               description: "My Description")
      review1 = create(:review, content: "Content1")
      review2 = create(:review, content: "Content2")
      review3 = create(:review, content: "Content3")
      create(:project_review, project_id: project.id,
                              review_id: review1.id)
      create(:project_review, project_id: project.id,
                              review_id: review2.id)
      create(:project_review, project_id: project.id,
                              review_id: review3.id)

      expect(project.reviews.length).to eq(3)
    end

    it 'has an owner' do
      project = Project.create(title: "My Title",
                               description: "My Description")
      owner = create(:user, name: 'Sally',
                            email: 'sally@email.com')
      create(:project_owner, project_id: project.id,
                             user_id: owner.id)

      expect(project.owner).to eq(owner)      
    end

    it 'has many users invited to review' do
      project = Project.create(title: "My Title",
                               description: "My Description")
      invite1 = create(:user, name: "Sally",
                              email: 'sally@email.com')
      invite2 = create(:user, name: "Molly",
                              email: 'molly@email.com')
      invite3 = create(:user, name: "Polly",
                              email: 'polly@email.com')
      create(:project_invite, project_id: project.id,
                              user_id: invite1.id)
      create(:project_invite, project_id: project.id,
                              user_id: invite2.id)
      create(:project_invite, project_id: project.id,
                              user_id: invite3.id)

      expect(project.invites.length).to eq(3)
    end
  end

  describe '#get_error_message' do
    it 'returns message requesting title if it is omitted' do
      project = Project.create(description: 'A description for the ages')

      expect(project.get_error_message).to eq("Please provide a title")
    end

    it 'returns message requesting description if it is omitted' do
      project = Project.create(title: 'A title for the ages', description: '')

      expect(project.get_error_message).to eq("Please provide a description")
    end

    it 'returns message requesting title and description if both are omitted' do
      project = Project.create(title: '', description: '')

      expect(project.get_error_message).to eq("Please provide a title and description")
    end
  end

  describe '#positive_reviews_count' do
    it 'returns the number of reviews that are positive' do
      project = create(:project)
      review1 = Review.create(content: 'Looks good')
      review2 = Review.create(content: 'Looks bad')
      review3 = Review.create(content: 'Looks great')
      rating_good = Rating.create(helpful: true)
      rating_bad = Rating.create(helpful: false)
      ProjectReview.create(project_id: project.id, review_id: review1.id)
      ProjectReview.create(project_id: project.id, review_id: review2.id)
      ProjectReview.create(project_id: project.id, review_id: review3.id)
      ReviewRating.create(review_id: review1.id, rating_id: rating_good.id)
      ReviewRating.create(review_id: review2.id, rating_id: rating_bad.id)
      ReviewRating.create(review_id: review3.id, rating_id: rating_good.id)
      reviews = [review1, review2, review3]

      expect(project.positive_reviews_count).to eq(2)
    end
  end
end
