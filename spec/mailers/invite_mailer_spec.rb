require "rails_helper"

RSpec.describe InviteMailer, type: :mailer do
  it "sends out an invite email" do
    project = create(:project, title: "Best Project")
    user = create(:user, name: "name1",
                         email: "name1@email.com",
                         uid: "uidname1")
    owner = create(:user, name: "name2",
                          email: "name2@email.com",
                          uid: "uidname2")
    project_invite = create(:project_owner, project_id: project.id,
                                            user_id: user.id)
    project_owner = create(:project_owner, project_id: project.id,
                                           user_id: owner.id)
                                           
    email = InviteMailer.invite_email(project, user).deliver_now

    expect(email.subject).to eq("You are invited to review " + project.title)
    expect(email.to).to eq([user.email])
    expect(email.body.encoded).to include(project.title)
    expect(email.body.encoded).to include(project.description)
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end
end
