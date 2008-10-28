class ProjectsController < ApplicationController
  before_filter :set_project, :except => :index
  before_filter :set_filter, :only => :show
  before_filter :set_tickets, :only => :show

  def index
    @projects = Project.all
    @sprints = Sprint.all :order => "name DESC"
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
    @users = User.all
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
    
    def set_tickets
      @tickets = @project.tickets.find :all, :conditions => @filter.sql
    end
    
    def set_filter
      @filter = TicketListFilter.new @project, params[:filter]
    end
end
