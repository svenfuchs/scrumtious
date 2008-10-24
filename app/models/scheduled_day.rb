class ScheduledDay < ActiveRecord::Base
  belongs_to :user
  
  def hours=(hours)
    self.minutes = hours * 60
  end
  
  def hours
    minutes.to_f / 60
  end
end