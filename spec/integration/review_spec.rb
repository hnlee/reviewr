require 'spec_helper'

describe 'review', :type => :feature do
  describe 'show page with ratings' do
    it 'shows all ratings in a review' do
      review = create(:review, content: "Looks good!")
      rating = create(:rating, helpful: true)
      create(:review_rating, review_id: review.id,
                             rating_id: rating.id)

      visit '/reviews/' + review.id.to_s

      expect(page).to have_content(review.content)
      expect(page).to have_content("Kind, specific, actionable: true")
    end
  end
end
