class Burndown
  def initialize(scope, start_at, end_at)
    @scope, @start_at, @end_at = scope, start_at, end_at
    raise "start_at and end_at must be not nil" if  @start_at.nil? or @end_at.nil?
  end
  
  # def data
  #   @data ||= begin
  #     data = []
  #     e, a = collect_estimated, collect_actual
  #     until e.empty?
  #       day, estimated, day, actual = *(e.shift + a.shift)
  #       remaining = (estimated - actual).round(1)
  #       data << [day, {:estimated => estimated, :actual => actual, :remaining => remaining}]
  #     end
  #     data
  #   end
  # end
  
  def data
    @data ||= begin
      data = [[], [], []]
      e, a = collect_estimated, collect_actual
      until e.empty?
        day, estimated, day, actual = *(e.shift + a.shift)
        data[0] << estimated
        data[1] << actual.round(1)
        data[2] << (estimated - actual).round(1)
      end
      data
    end
  end
  
  def gchart
    require 'gchart'
    GChart.line :title => "Burndown chart", 
                :data => data, 
                :legend => ['estimated', 'actual', 'remaining'],
                :colors => ["ff4400", "0066ff", "00ff00"]
  end
  
  protected
  
    def collect_actual
      end_at = [Time.zone.today, @end_at].min
      remaining = (@start_at..end_at).to_a.map do |day|
        [day, Array(@scope).map do |ticket|
          ticket.actual_at(day)
        end.sum]
      end
      @scope.is_a?(Array) ? remaining : remaining.first
    end
  
    def collect_estimated
      end_at = [Time.zone.today, @end_at].min
      estimated = (@start_at..end_at).to_a.map do |day|
        [day, Array(@scope).map do |ticket|
          ticket.estimated_at(day)
        end.sum]
      end
      @scope.is_a?(Array) ? estimated : estimated.first
    end
end