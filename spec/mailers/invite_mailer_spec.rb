require "rails_helper"

RSpec.describe InviteMailer, type: :mailer do
  describe "invite_mail" do
    it "sends out an invite email" do
      project = create(:project, title: "Best Project")
      user = create(:user, name: "name1",
                           email: "name1@email.com",
                           uid: "uidname1")
      owner = create(:user, name: "name2",
                            email: "name2@email.com",
                            uid: "uidname2")
      project_owner = create(:project_owner, project_id: project.id,
                                             user_id: owner.id)
                                             
      email = InviteMailer.invite_email(project, user).deliver_now

      expect(email.subject).to eq("You are invited to review " + project.title)
      expect(email.to).to eq([user.email])
      expect(email.body.encoded).to include(project.title)
      expect(email.body.encoded).to include(project.description)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  describe "uninvite_email" do
    it "sends out an uninvite email" do 
      project = create(:project, title: "Best Project")
      user = create(:user, name: "name1",
                           email: "name1@email.com",
                           uid: "uidname1")
      owner = create(:user, name: "name2",
                            email: "name2@email.com",
                            uid: "uidname2")
      project_owner = create(:project_owner, project_id: project.id,
                                             user_id: owner.id)
                                             
      email = InviteMailer.uninvite_email(project, user).deliver_now

      expect(email.subject).to eq("You no longer have access to review " + project.title)
      expect(email.to).to eq([user.email])
      expect(email.body.encoded).to include(project.title)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end
end
