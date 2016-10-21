require 'rails_helper'

RSpec.describe Rating do
  it 'has 3 booleans set' do
    rating = Rating.new(kind: true,
                        specific: true,
                        actionable: true)

    expect(rating.kind).to eq(true)
    expect(rating.specific).to eq(true)
    expect(rating.actionable).to eq(true)
  end
end
