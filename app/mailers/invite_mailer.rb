class InviteMailer < ApplicationMailer
  layout "mailer"

  def invite_email(project, user)
    @user = user
    @project = project
    mail(to: @user.email,
         subject: "You are invited to review " + @project.title)
  end

  def uninvite_email(project, user)
    @user = user
    @project = project
    mail(to: @user.email,
         subject: "You no longer have access to review " + @project.title)
  end
end
