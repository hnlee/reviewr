require "rails_helper"

RSpec.describe ProjectInvite do
  it "belongs to a project and a user" do
    project = create(:project)
    user = create(:user)
    project_invite = ProjectInvite.new(project_id: project.id,
                                       user_id: user.id)

    expect(project_invite.project).to eq(project)
    expect(project_invite.user).to eq(user)
  end
end
