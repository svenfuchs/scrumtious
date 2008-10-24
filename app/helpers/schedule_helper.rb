module ScheduleHelper
  def schedule_id(schedule, user, day)
    "schedule-#{user.id}-#{day.strftime('%Y-%m-%d')}"
  end
end