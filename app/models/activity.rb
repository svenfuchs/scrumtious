class Activity < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  
  def update_attributes(attributes)
    state = attributes.delete :state
    super and begin
      self.state = state # make sure state is set last
      save # TODO figure out how to save just once
    end
  end
  
  def state
    started? ? 'started' : 'stopped'
  end
  
  def state=(state)
    case state
    when 'started': start!
    when 'stopped': stop!
    end
  end
  
  def stop!
    self.minutes = self.minutes.to_i + (Time.zone.now - self.started_at) / 60 if self.started_at
    self.started_at = nil
    self.stopped_at = Time.zone.now
  end

  def start!
    user.activities.current.stop! if user and user.activities.current
    self.started_at = Time.zone.now
    self.stopped_at = nil
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
end