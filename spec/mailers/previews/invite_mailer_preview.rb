# Preview all emails at http://localhost:3000/rails/mailers/invite_mailer
class InviteMailerPreview < ActionMailer::Preview
  def invite_email
    project_invite = ProjectInvite.first
    InviteMailer.invite_email(Project.find(project_invite.project_id),
                              User.find(project_invite.user_id)) 
  end
end
