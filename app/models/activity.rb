class Activity < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  
  def state
    started? ? 'started' : 'stopped'
  end
  
  def state=(state)
    case state
    when 'started': start!
    when 'stopped': stop!
    end
  end
  
  def started?
    !started_at.nil?
  end
  
  def state_changed_at
    started? ? started_at : stopped_at
  end
  
  def total_minutes
    self.minutes.to_i + (self.started_at ? (Time.zone.now - self.started_at) / 60 : 0)
  end
  
  def hours=(hours)
    self.minutes = hours.to_f * 60
  end
  
  def hours
    minutes.to_f / 60
  end
  
  protected
  
    def stop!
      self.minutes = self.minutes.to_i + (Time.zone.now - self.started_at) / 60
      self.started_at = nil
      self.stopped_at = Time.zone.now
    end
  
    def start!
      self.started_at = Time.zone.now
      self.stopped_at = nil
    end
end