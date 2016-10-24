require 'rails_helper'

RSpec.describe Review do
  it 'has content' do
    review = Review.new(content: "Looks good!")

    expect(review.content).to eq("Looks good!")
  end
end
