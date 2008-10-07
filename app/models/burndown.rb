class Burndown
  class Row
    attr_reader :day, :estimated, :actual
    
    def initialize(day, estimated = nil, actual = nil)
      @day, @estimated, @actual = day, estimated, actual.round(1)
    end
    
    def remaining
      (estimated - actual).round(1)
    end
    
    def values
      [estimated, actual, remaining]
    end
  end
  
  attr_reader :rows
  
  def initialize(scope, start_at, end_at)
    raise "start_at and end_at must be not nil" if  start_at.nil? or end_at.nil?
    @scope, @start_at, @end_at = scope, start_at, end_at
    @rows = []
    collect!
  end
  
  def days
    @days ||= rows.map(&:day)
  end
  
  def data
    @data ||= rows.map(&:values)
  end
  
  def gchart
    require 'gchart'
    data = self.data.transpose << [0,0,0,0,0,1]
    p data
    GChart.xyline :title => "Burndown chart", 
                  :data => data, 
                  :legend => ['estimated', 'actual', 'remaining'],
                  :colors => ["ff4400", "0066ff", "00ff00"]
  end
  
  protected
  
    def collect!
      rows.clear
      end_at = [Time.zone.today, @end_at].min
      remaining = (@start_at..end_at).to_a.each do |day|
        estimated, actual = collect_attribute(:estimated_at, day), collect_attribute(:actual_at, day)
        @rows << Row.new(day, estimated, actual)
      end
    end
    
    def collect_attribute(attribute, day)
      Array(@scope).map{|ticket| ticket.send(attribute, day) }.sum
    end
end