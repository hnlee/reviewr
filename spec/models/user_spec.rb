require 'rails_helper'

RSpec.describe User do
  it 'has a name, email, and password' do
    user = User.new(name: 'Sally',
                    email: 'sally@email.com',
                    password: 'password')
    
    expect(user.name).to eq('Sally')
    expect(user.email).to eq('sally@email.com')
    expect(user.password).to eq('password')
  end

  it 'has many projects it owns' do
    user = User.create(name: 'Molly',
                       email: 'molly@email.com',
                       password: 'password')
    project1 = create(:project, title: 'project 1')
    project2 = create(:project, title: 'project 2')
    project3 = create(:project, title: 'project 3')
    create(:project_owner, user_id: user.id,
                           project_id: project1.id)
    create(:project_owner, user_id: user.id,
                           project_id: project2.id)
    create(:project_owner, user_id: user.id,
                           project_id: project3.id)

    expect(user.projects.length).to eq(3)
  end

  it 'has many projects for which it has been invited to review' do
    user = User.create(name: 'Polly',
                       email: 'polly@email.com',
                       password: 'password')
    project1 = create(:project, title: 'project 1')
    project2 = create(:project, title: 'project 2')
    create(:project_invite, user_id: user.id,
                            project_id: project1.id)
    create(:project_invite, user_id: user.id,
                            project_id: project2.id)

    expect(user.invites.length).to eq(2)
  end

  it 'has many reviews it has written' do
    user = User.create(name: 'Sally',
                       email: 'sally@email.com',
                       password: 'password')
    review1 = create(:review)
    review2 = create(:review)
    create(:user_review, user_id: user.id,
                         review_id: review1.id)
    create(:user_review, user_id: user.id,
                         review_id: review2.id)

    expect(user.reviews.length).to eq(2)
  end

  it 'has many ratings it has given' do
    user = User.create(name: 'Molly',
                       email: 'molly@email.com',
                       password: 'password')
    rating1 = create(:rating, helpful: true)
    rating2 = create(:rating, helpful: true, 
                              explanation: 'Very thorough')
    rating3 = create(:rating, helpful: true,
                              explanation: 'Needs more detail')
    create(:user_rating, user_id: user.id,
                         rating_id: rating1.id)
    create(:user_rating, user_id: user.id,
                         rating_id: rating2.id)
    create(:user_rating, user_id: user.id,
                         rating_id: rating3.id)

    expect(user.ratings.length).to eq(3)
  end
end
