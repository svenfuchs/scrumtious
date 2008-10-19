class Burndown
  class Row
    attr_reader :day, :estimated, :actual
    
    def initialize(day, estimated = nil, actual = nil)
      @day, @estimated, @actual = day, estimated, actual.to_f.round(1)
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
    raise "start_at and end_at must be not nil" if start_at.nil? or end_at.nil?
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
    GChart.line :title => "Burndown chart", 
                :data => data.transpose, 
                :legend => ['estimated', 'actual', 'remaining'],
                :colors => ["ff4400", "0066ff", "00ff00"]
  end
  
  def amchart
    colors = %w{#B40000 #F7941D #0265AC}
    chart = Ambling::Data::ColumnChart.new
    
    chart.graphs << estimated = Ambling::Data::LineGraph.new([], :title => "estimated", :color => colors[0])
    chart.graphs << actual = Ambling::Data::LineGraph.new([], :title => "actual", :color => colors[1])
    chart.graphs << remaining = Ambling::Data::LineGraph.new([], :title => "remaining", :color => colors[2])
    rows.each do |row|
      chart.series << Ambling::Data::Value.new(row.day.strftime('%a, %d.%m.'), :xid => row.day)
      
      estimated << Ambling::Data::Value.new(row.estimated, :xid => row.day)
      actual << Ambling::Data::Value.new(row.actual, :xid => row.day)
      remaining << Ambling::Data::Value.new(row.remaining, :xid => row.day)
    end
    chart
  end
  
  protected
  
    def collect!
      rows.clear
      end_at = [Time.zone.today, @end_at].min
      actual_total = 0.0
      (@start_at..end_at).to_a.each do |day|
        actual_total = actual_total + actual_at(day)
        @rows << Row.new(day, estimated_at(day), actual_total)
      end
    end
    
    def estimated_at(day)
      Array(@scope).map{|ticket| ticket.estimated_at day }.sum
    end
    
    def actual_at(day)
      Array(@scope).map{|ticket| ticket.activities.total(day) / 60 }.sum
    end
end