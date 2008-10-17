class ScheduleController < ApplicationController
  before_filter :set_project
  before_filter :set_schedule, :only => :index
  
  def index
    @members = @project.members.sort_by &:first_name
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
    
    def set_schedule
      @schedule = Schedule.new @project, first_week_day, first_week_day + 4.weeks
    end
  
    def first_week_day
      today = Time.zone.today
      Time.zone.local(today.year, today.month, today.day - day_of_week(today)).to_date
    end
  
    def day_of_week(date)
      day = date.strftime('%w').to_i
      day == 0 ? 6 : day - 1
    end
end