class SynchronizersController < ApplicationController
  before_filter :set_synchronizer
  before_filter :set_project

  def new
  end

  def create
    if @synchronizer.pull!
      flash[:notice] = 'Synchronizer has successfully run.'
      redirect_to @synchronizer.project
    else
      render :action => "new"
    end
  end
  
  protected
  
    def set_synchronizer
      @synchronizer = Synchronizer.new(params[:project_id])
    end
  
    def set_project
      @project = @synchronizer.project
    end
end
