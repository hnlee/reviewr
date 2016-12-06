require "rails_helper"

RSpec.describe ProjectOwner do
  it "belongs to a project and a user" do
    project = create(:project)
    user = create(:user)
    project_owner = ProjectOwner.new(project_id: project.id,
                                     user_id: user.id)

    expect(project_owner.project).to eq(project)
    expect(project_owner.user).to eq(user)
  end
end
