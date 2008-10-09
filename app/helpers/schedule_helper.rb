module ScheduleHelper
  def schedule_id(schedule, user, day)
    "schedule-#{schedule.project.id}-#{day.strftime('%Y-%m-%d')}-#{user.id}"
  end
end