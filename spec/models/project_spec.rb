require 'rails_helper'

RSpec.describe Project do
  it 'has a title and description' do
    project = Project.new(title: "My Title",
                          description: "My Description")

    expect(project.title).to eq("My Title")
    expect(project.description).to eq("My Description")
  end
end
