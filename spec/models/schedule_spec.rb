require File.dirname(__FILE__) + '/../spec_helper'

describe Schedule, '#days' do
  it "returns weeks * 7 days starting from the first day of the current week" do
    @monday = Date.parse('2008-10-06')
    @thursday = Date.parse('2008-10-09')
    schedule = Schedule.new nil, @thursday, 2
    expected = (@monday..(@monday + 2.weeks - 1.day)).to_a
    schedule.days.should == expected
  end
end

describe Schedule, '#days_range' do
  before :each do 
    @monday = Date.parse('2008-10-06')
    @thursday = Date.parse('2008-10-09')
    @sunday = Date.parse('2008-10-12')
    @schedule = Schedule.new nil, @thursday
  end
  
  it "returns a range of days containing the given start day when no end day was given" do
    @schedule.send(:days_range, @thursday, nil).should == (@thursday..@thursday)
  end
  
  it "returns a range of days starting with the given start day and ending with the given end day when both are given" do
    @schedule.send(:days_range, @thursday, @sunday).should == (@thursday..@sunday)
  end
  
  it "returns a range of days starting and ending with the schedule's start/end days when no days are given" do
    @schedule.send(:days_range, nil, nil).should == (@schedule.start_at..@schedule.end_at)
  end
end

# describe Schedule, '#day_of_week' do
#   it "returns 0 for a Monday" do
#     schedule = Schedule.new nil, Date.parse('2008-10-06')
#     schedule.send(:day_of_week).should == 0
#   end
# 
#   it "returns 1 for a Tuesday" do
#     schedule = Schedule.new nil, Date.parse('2008-10-07')
#     schedule.send(:day_of_week).should == 1
#   end
# 
#   it "returns 2 for a Wednesday" do
#     schedule = Schedule.new nil, Date.parse('2008-10-08')
#     schedule.send(:day_of_week).should == 2
#   end
# 
#   it "returns 3 for a Thursday" do
#     schedule = Schedule.new nil, Date.parse('2008-10-09')
#     schedule.send(:day_of_week).should == 3
#   end
# 
#   it "returns 4 for a Friday" do
#     schedule = Schedule.new nil, Date.parse('2008-10-10')
#     schedule.send(:day_of_week).should == 4
#   end
# 
#   it "returns 5 for a Saturday" do
#     schedule = Schedule.new nil, Date.parse('2008-10-11')
#     schedule.send(:day_of_week).should == 5
#   end
# 
#   it "returns 6 for a Sunday" do
#     schedule = Schedule.new nil, Date.parse('2008-10-12')
#     schedule.send(:day_of_week).should == 6
#   end
# end
