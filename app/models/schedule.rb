class Schedule
  attr_reader :start_at, :end_at
  
  def initialize(start_at = nil, end_at = nil)
    @start_at = start_at || Time.zone.today
    @end_at = end_at || (@start_at + 27.days)
  end
    
  def days(end_at = nil)
    return [] unless start_at
    end_at ||= self.end_at
    (0..(end_at - start_at).to_i).collect{|i| start_at + i.days } # TODO hu?
  end
  
  def used_days
    days [end_at, Time.zone.today].min
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
    
    def scheduled_days
      @scheduled_days = ScheduledDay.find :all, :conditions => ["? <= day and day <= ?", start_at, end_at]
    end
end