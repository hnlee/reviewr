require 'rails_helper'

RSpec.describe Rating do
  it 'has helpful boolean set' do
    rating = Rating.new(helpful: true)

    expect(rating.helpful).to eq(true)
  end
  it' does not save if helpful field is not set' do
    rating = Rating.new()

    expect(rating.id).to eq(nil)
  end
end
