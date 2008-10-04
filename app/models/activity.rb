class Activity < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  
  def started=(time)
    if time.blank? and self.started
      self.minutes = self.minutes.to_i + (Time.zone.now - self.started) / 60
    end
    self[:started] = time
  end
  
  def hours=(hours)
    self.minutes = hours.to_f * 60
  end
  
  def hours
    minutes.to_f / 60
  end
end