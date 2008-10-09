class SprintsController < ApplicationController
  before_filter :set_sprint
  before_filter :set_release
  before_filter :set_project
  
  def show
    params[:sort] ||= 'assigned'
    @tickets = @sprint.tickets.ordered params[:sort]
    @tickets = (params[:sort] == 'assigned') ? @tickets.group_by(&:user) : {nil => @tickets}
    @schedule = Schedule.new @project
  end

  def new
  end

  def create
    if @sprint.save
      flash[:notice] = 'Sprint has been created.'
      redirect_to @sprint
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @sprint.update_attributes(params[:sprint])
      flash[:notice] = 'Sprint has been updated.'
      redirect_to @sprint
    else
      render :action => "edit"
    end
  end

  def destroy
    @sprint.destroy
    redirect_to release_url(@sprint.release)
  end
  
  protected
  
    def set_sprint
      @sprint = params[:id] ? Sprint.find(params[:id]) : Sprint.new(params[:sprint])
    end
    
    def set_release
      @release = @sprint.release if @sprint
    end
    
    def set_project
      @project = @sprint.project if @sprint
    end
end
