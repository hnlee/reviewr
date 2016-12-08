class ProjectsController < ApplicationController

  def show
    @project = Project.find_by_id(params[:id])
    if logged_out?
      redirect_to root_path
    elsif current_user == @project.owner
      @user = current_user
      @reviews = @project.reviews.order(updated_at: :desc)
    elsif @project.get_invited_reviewers.include?(current_user) or @project.get_reviewers.include?(current_user)
      @user = current_user
      @reviews = Review.get_user_owned_reviews(@user,
                                               @project)
      @create = params[:create]
      if @create == "success"
        flash.now[:notice] = "Review has been created"
      end
    else
      redirect_to user_path(current_user.id)
    end
  end

  def new
    if logged_out?
      redirect_to root_path
    else
      @project = Project.new
      @user = current_user
    end
  end

  def create
    project = Project.new(title: project_params[:title],
                          link: project_params[:link],
                          description: project_params[:description])
    emails = params[:emails]
    if project.save
      ProjectOwner.create(project_id: project.id,
                          user_id: current_user.id)
      emails.each do |email|
        user = User.find_or_create_by(email: email)
        ProjectInvite.create(project_id: project.id,
                             user_id: user.id)
        InviteMailer.invite_email(project, user).deliver_now
      end
      redirect_to user_path(current_user.id), { flash: { notice: "Project has been created" } } 
    else
      redirect_to new_project_path(user: project_params[:user_id]), { flash: { error: project.get_error_message } }
    end
  end

  def edit
    @project = Project.find_by_id(params[:id])
    @invited_reviewers = @project.get_invited_reviewers
    if logged_out?
      redirect_to root_path
    elsif current_user != @project.owner
      redirect_to user_path(current_user.id)
    else
    end
  end

  def update
    @project = Project.find_by_id(params[:id])
    @invited_reviewers = @project.get_invited_reviewers
    emails = params[:emails]
    if @project.update_attributes(project_params)
      if emails
        emails.each do |email|
          if !@invited_reviewers.find_by(email: email)
            user = User.find_or_create_by(email: email)
            ProjectInvite.create(project_id: @project.id,
                                 user_id: user.id)
            InviteMailer.invite_email(@project, user).deliver_now
          end
        end
      end
      @invited_reviewers.each do |invited_reviewer|
        if !emails or !emails.include?(invited_reviewer.email)
          invite = ProjectInvite.find_by(user_id: invited_reviewer.id, 
                                         project_id: @project.id)
          ProjectInvite.destroy(invite.id)
          InviteMailer.uninvite_email(@project, invited_reviewer).deliver_now
        end
      end
      redirect_to project_path(params[:id]), { flash: { notice: "Project has been updated" } }
    else
      redirect_to edit_project_path(params[:id]), { flash: { error: @project.get_error_message } }
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :link, :description, :user_id)
  end

end
