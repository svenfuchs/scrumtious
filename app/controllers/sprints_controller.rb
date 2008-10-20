class SprintsController < ApplicationController
  before_filter :set_sprint
  
  def show
    params[:sort] ||= 'assigned'
    @ticket_groups = @sprint.ticket_groups params[:sort]
  end

  def new
  end

  def create
    if @sprint.save
      @sprint.push!
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
      @sprint.push!
      flash[:notice] = 'Sprint has been updated.'
      redirect_to @sprint
    else
      render :action => "edit"
    end
  end

  def destroy
    @sprint.destroy
    redirect_to projects_url
  end
  
  protected
  
    def set_sprint
      @sprint = params[:id] ? Sprint.find(params[:id]) : Sprint.new(params[:sprint])
    end
end
