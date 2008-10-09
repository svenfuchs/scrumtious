class Schedule
  attr_reader :project
  
  def initialize(project, day = Time.zone.today, weeks = 4)
    @project = project
    @day = day
    @weeks = weeks
  end
  
  def start_at
    first_week_day
  end
  
  def end_at
    (start_at + 6.days).to_date
  end
  
  def days
    (start_at..end_at).to_a
  end
  
  def hours(user, day = nil)
    scheduled_days.select{|d| (day.nil? or d.day == day) and d.user_id == user.id }.map(&:hours).sum
  end
  
  private
  
    def first_week_day
      Time.zone.local(@day.year, @day.month, @day.day - day_of_week).to_date
    end
  
    def day_of_week
      day = @day.strftime('%w').to_i
      day == 0 ? 6 : day - 1
    end
    
    def scheduled_days
      @scheduled_days = ScheduledDay.find :all, :conditions => ["? <= day and day <= ?", start_at, end_at]
    end
end