class Schedule
  attr_reader :project
  
  def initialize(project, day = Time.zone.today, weeks = 4)
    @project = project
    @day = day
    @weeks = weeks
  end
  
  def start_at
    first_week_day.to_date
  end
  
  def end_at
    (start_at + (days_count - 1).days).to_date
  end
  
  def days_count
    @weeks * 7
  end
  
  def days
    (start_at..end_at).to_a
  end
  
  def hours(user, start_at = nil, end_at = nil)
    range = days_range(start_at, end_at)
    days = scheduled_days.select{|s| range.include?(s.day) and s.user_id == user.id }
    days.map(&:hours).sum
  end
  
  private
  
    def days_range(start_at, end_at)
      start_at ? (end_at = start_at) : (start_at, end_at = self.start_at, self.end_at) if end_at.blank?
      start_at..end_at
    end
  
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