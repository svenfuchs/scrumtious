class ScheduleController < ApplicationController
  before_filter :set_schedule, :only => :index
  
  def index
    @members = Project.all.map(&:members).flatten.uniq.sort_by(&:first_name)
  end
  
  def update
    user_id, day = params[:user_id], params[:id]
    conditions = ["user_id = ? and date(day) = ?", user_id, day]
    day = ScheduledDay.find(:first, :conditions => conditions) ||
          ScheduledDay.new(:user_id => user_id, :day => day)
    day.hours = params[:hours]
    day.save!
    head :ok
  end
  
  protected
  
    def set_schedule
      @schedule = Schedule.new first_week_day, first_week_day + 4.weeks
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