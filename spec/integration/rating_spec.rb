require 'spec_helper'

describe 'rating', :type => :feature do
  describe 'review show page with ratings' do
    it 'shows all ratings in a review' do
      review = create(:review, content: "Looks good!")
      rating = create(:rating, kind: true,
                               specific: true,
                               actionable: true)
      create(:review_rating, review_id: review.id,
                             rating_id: rating.id)

      visit '/reviews/' + review.id.to_s

      expect(page).to have_content(review.content)
      expect(page).to have_content("Kind: true")
      expect(page).to have_content("Specific: true")
      expect(page).to have_content("Actionable: true")
    end
  end

  describe 'link to new rating page' do
    it 'creates a new rating' do
      review = create(:review, content: 'This looks really good!')
      rating_values = [true, true, true]

      visit new_rating_path(review)
      choose('rating_kind_true')
      choose('rating_actionable_true')
      choose('rating_specific_true')
      click_button('Rate review')

      expect(page).to have_content("Kind: true")
      expect(page).to have_content("Specific: true")
      expect(page).to have_content("Actionable: true")
    end
  end

  describe 'if not from a review page' do
    it 'redirects to projects show' do
      visit new_rating_path

      expect(current_path).to eq(projects_path)
    end
  end
end
