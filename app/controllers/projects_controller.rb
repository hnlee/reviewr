class ProjectsController < ApplicationController

  def show
    @project = Project.find_by_id(params[:id])
    if logged_out?
      redirect_to root_path
    elsif current_user == @project.owner
      @user = current_user
      @reviews = @project.reviews.order(updated_at: :desc)
    elsif @project.get_invites.include?(current_user) or @project.get_reviewers.include?(current_user)
      @user = current_user
      @reviews = Review.get_user_owned_reviews(@user,
                                               @project)
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
                          description: project_params[:description])
    emails = params[:emails]
    if project.save
      ProjectOwner.create(project_id: project.id,
                          user_id: current_user.id)
      if emails
        emails.each do |email|
          user = User.find_or_create_by(email: email)
          ProjectInvite.create(project_id: project.id,
                               user_id: user.id)
        end
      end
      redirect_to user_path(current_user.id)
    else
      redirect_to new_project_path(user: project_params[:user_id]), { flash: { error: project.get_error_message } }
    end
  end

  def edit
    @project = Project.find_by_id(params[:id])
    if logged_out?
      redirect_to root_path
    elsif current_user != @project.owner
      redirect_to user_path(current_user.id)
    else
    end
  end

  def update
    @project = Project.find_by_id(params[:id])
    if @project.update_attributes(project_params)
      redirect_to project_path(params[:id]), { flash: { notice: "Project has been updated" } }
    else
      redirect_to edit_project_path(params[:id]), { flash: { error: @project.get_error_message } }
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :user_id)
  end

end
