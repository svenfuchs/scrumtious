class ActivitiesController < ApplicationController
  before_filter :set_activity

  def index
    @activities = Activity.all(:order => "started DESC, id DESC", :limit => 100)
  end

  def create
    if @activity.save
      flash[:notice] = 'Activity has been created.'
      redirect_back_or_default activities_path
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @activity.update_attributes(params[:activity])
      flash[:notice] = "Activity has been #{activity_msg_state}"
      redirect_back_or_default activities_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @activity.destroy
    redirect_to activities_url
  end
  
  protected
  
    def set_activity
      @activity = params[:id] ? Activity.find(params[:id]) : Activity.new(params[:activity])
    end
    
    def set_project
      @project = @activity.project if @activity
    end
    
    def activity_msg_state
      params[:activity][:state] ? params[:activity][:state] : 'updated'
    end
end
