class ScheduleController < ApplicationController
  before_filter :set_project
  
  def index
    @members = @project.members.sort_by &:first_name
    @schedule = Schedule.new @project
  end
  
  def update
    project_id, user_id, day = params[:project_id], params[:user_id], params[:id]
    conditions = ["project_id = ? and user_id = ? and date(day) = ?", project_id, user_id, day]
    day = ScheduledDay.find(:first, :conditions => conditions) ||
          ScheduledDay.new(:project_id => project_id, :user_id => user_id, :day => day)
    day.hours = params[:hours]
    day.save!
    render :text => :ok
  end
  
  protected
  
    def set_project
      @project = Project.find params[:project_id]
    end
  
end