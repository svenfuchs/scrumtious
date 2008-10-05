class ComponentsController < ApplicationController
  before_filter :set_component
  before_filter :set_project

  def new
  end

  def create
    if @component.save
      flash[:notice] = 'Component was successfully created.'
      redirect_to edit_project_path(@component.project)
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @component.update_attributes(params[:component])
      flash[:notice] = 'Component was successfully updated.'
      redirect_to edit_project_path(@component.project)
    else
      render :action => "edit"
    end
  end

  def destroy
    @component.destroy
    redirect_to components_url
  end
  
  protected
  
    def set_component
      @component = params[:id] ? Component.find(params[:id]) : Component.new(params[:component])
    end
    
    def set_project
      @project = @component.project if @component
    end
end
