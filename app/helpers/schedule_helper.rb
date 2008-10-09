module ScheduleHelper
  def schedule_id(schedule, user, day)
    "schedule-#{schedule.project.id}-#{user.id}-#{day.strftime('%Y-%m-%d')}"
  end
end