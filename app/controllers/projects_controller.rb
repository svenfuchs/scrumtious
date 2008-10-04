class ProjectsController < ApplicationController
  before_filter :set_project, :except => :index

  def index
    @projects = Project.find(:all)
  end

  def show
  end

  def new
  end

  def create
    if @project.save
      flash[:notice] = 'Project has been created.'
      redirect_to(@project)
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @project.update_attributes(params[:project])
      flash[:notice] = 'Project has been updated.'
      redirect_to(@project)
    else
      render :action => "edit"
    end
  end

  def destroy
    @project.destroy
    redirect_to(projects_url)
  end
  
  protected
  
    def set_project
      @project = params[:id] ? Project.find(params[:id]) : Project.new(params[:project])
    end
end
