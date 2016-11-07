require 'rails_helper'

RSpec.describe Project do
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
                          email: 'sally@email.com',
                          password: 'password')
    create(:project_owner, project_id: project.id,
                           user_id: owner.id)

    expect(project.owner).to eq(owner)      
  end

  it 'has many users invited to review' do
    project = Project.create(title: "My Title",
                             description: "My Description")
    invite1 = create(:user, name: "Sally",
                            email: 'sally@email.com',
                            password: 'password')
    invite2 = create(:user, name: "Molly",
                            email: 'molly@email.com',
                            password: 'password')
    invite3 = create(:user, name: "Polly",
                            email: 'polly@email.com',
                            password: 'password')
    create(:project_invite, project_id: project.id,
                            user_id: invite1.id)
    create(:project_invite, project_id: project.id,
                            user_id: invite2.id)
    create(:project_invite, project_id: project.id,
                            user_id: invite3.id)

    expect(project.invites.length).to eq(3)
  end
end
