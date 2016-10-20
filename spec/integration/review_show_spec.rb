require 'spec_helper'

describe 'review show page with ratings' do
  it 'shows all ratings in a review' do
    project = create(:project, title: "Java Tic-Tac-Toe")
    review = create(:review, content: "Looks good!", project_id: project.id)
    rating = create(:rating, review_id: review.id)

    ["kind", "actionable", "specific"].each do |category|
      create(:rating_check, rating_id: rating.id,
                            category: category,
                            value: true)
    end
   
    visit '/projects/' + project.id.to_s + '/reviews/' + review.id.to_s

    expect(page).to have_content(review.content)

    expect(page).to have_content("Kind? Y")
    expect(page).to have_content("Actionable? Y")
    expect(page).to have_content("Specific? Y")

  end
end
