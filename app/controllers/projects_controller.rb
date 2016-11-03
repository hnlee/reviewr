class ProjectsController < ApplicationController

  def index
    @projects = Project.order(updated_at: :desc).all
    @review = Review.offset(rand(Review.count)).first
  end

  def show
    @project = Project.find_by_id(params[:id])
    @reviews = @project.reviews.order(updated_at: :desc)
    @review = Review.new
  end

  def new
    @project = Project.new
  end

  def create
    project = Project.new(title: project_params[:title],
                          description: project_params[:description])
    if project.save
      redirect_to projects_path
    else
      if project.title.blank? and project.description.blank?
        redirect_to new_project_path, { flash: { error: "Please provide a title and description" } }
      elsif project.description.blank?
        redirect_to new_project_path, { flash: { error: "Please provide a description" } }
      else
        redirect_to new_project_path, { flash: { error: "Please provide a title" } }
      end
    end
  end

  def edit
    @project = Project.find_by_id(params[:id])
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
    params.require(:project).permit(:title, :description)
  end
end
