class SprintsController < ApplicationController
  before_filter :set_sprint
  before_filter :set_release
  before_filter :set_project
  
  def show
    @tickets = @sprint.tickets.grouped(params[:sort] || 'assigned')
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
  
  # def burndown
  #   respond_to do |format|
  #     format.xml { render :xml => @sprint.burndown.amchart_data.to_xml }
  #   end
  # end
  
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
