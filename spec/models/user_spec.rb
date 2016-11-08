require 'rails_helper'

RSpec.describe User do
  it 'has a name and an email' do
    user = User.new(name: 'Sally',
                    email: 'sally@email.com')
    
    expect(user.name).to eq('Sally')
    expect(user.email).to eq('sally@email.com')
  end

  it 'has many projects it owns' do
    user = User.create(name: 'Molly',
                       email: 'molly@email.com')
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
                       email: 'polly@email.com')
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
                       email: 'sally@email.com')
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
                       email: 'molly@email.com')
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

  it 'can be created from an authentication hash' do
    auth_hash = { uid: 'uid',
                  info: { name: 'name',
                          email: 'name@email.com' } }
    user = User.from_omniauth(auth_hash) 

    expect(user.uid).to eq('uid')
    expect(user.name).to eq('name')
    expect(user.email).to eq('name@email.com')
  end
end
