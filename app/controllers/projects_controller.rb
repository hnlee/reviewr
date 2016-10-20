class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def show
    @project = Project.find_by_id(params[:id])
    @reviews = @project.reviews
  end
end
