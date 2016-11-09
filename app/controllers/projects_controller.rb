class ProjectsController < ApplicationController

  def index
    @projects = Project.order(updated_at: :desc).all
    @review = Review.offset(rand(Review.count)).first
  end

  def show
    @project = Project.find_by_id(params[:id])
    if session[:user_id].nil?
      redirect_to root_path
    elsif session[:user_id] != @project.owner.id
      redirect_to user_path(session[:user_id])
    else
      @reviews = @project.reviews.order(updated_at: :desc)
      @current_user_review = Review.includes(session[:user_id]).where(id: @reviews.map(&:id))
      @review = Review.new
    end
  end

  def new
    if session[:user_id].nil?
      redirect_to root_path
    else    
      @project = Project.new
      @user = current_user
    end
  end

  def create
    project = Project.new(title: project_params[:title],
                          description: project_params[:description])
    if project.save
      ProjectOwner.create(project_id: project.id,
                          user_id: current_user.id)
      redirect_to user_path(current_user.id)
    else
      if project.title.blank? and project.description.blank?
        redirect_to new_project_path(user: project_params[:user_id]), { flash: { error: "Please provide a title and description" } }
      elsif project.description.blank?
        redirect_to new_project_path(user: project_params[:user_id]), { flash: { error: "Please provide a description" } }
      else
        redirect_to new_project_path(user: project_params[:user_id]), { flash: { error: "Please provide a title" } }
      end
    end
  end

  def edit
    @project = Project.find_by_id(params[:id])
    if session[:user_id].nil?
      redirect_to root_path
    elsif session[:user_id] != @project.owner.id
      redirect_to user_path(session[:user_id])
    else
    end
  end

  def update
    @project = Project.find_by_id(params[:id])
    if @project.update_attributes(project_params)
      redirect_to project_path(params[:id]), { flash: { notice: "Project has been updated" } }
    else
      if @project.title.blank? and @project.description.blank?
        redirect_to edit_project_path(params[:id]), { flash: { error: "Please provide a title and description" } }
      elsif @project.description.blank?
        redirect_to edit_project_path(params[:id]), { flash: { error: "Please provide a description" } }
      else
        redirect_to edit_project_path(params[:id]), { flash: { error: "Please provide a title" } }
      end
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :user_id)
  end
end
