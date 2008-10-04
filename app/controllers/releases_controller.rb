class ReleasesController < ApplicationController
  before_filter :set_release
  before_filter :set_project
  
  def show
  end

  def new
  end

  def create
    if @release.save
      flash[:notice] = 'Release has been created.'
      redirect_to @release
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @release.update_attributes(params[:release])
      flash[:notice] = 'Release has been updated.'
      redirect_to @release
    else
      render :action => "edit"
    end
  end

  def destroy
    @release.destroy
    redirect_to project_path(@release.project)
  end
  
  protected
  
    def set_release
      @release = params[:id] ? Release.find(params[:id]) : Release.new(params[:release])
    end
    
    def set_project
      @project = @release.project if @release
    end
end
