require File.dirname(__FILE__) + '/../spec_helper'

describe Schedule, '#days' do
  it "returns weeks * 7 days starting from the first day of the current week" do
    schedule = Schedule.new nil, Date.parse('2008-10-09')
    schedule.days.map(&:to_s).should == %w(2008-10-06 2008-10-07 2008-10-08 2008-10-09 2008-10-10 2008-10-11 2008-10-12)
  end
end

describe Schedule, '#day_of_week' do
  it "returns 0 for a Monday" do
    schedule = Schedule.new nil, Date.parse('2008-10-06')
    schedule.send(:day_of_week).should == 0
  end

  it "returns 1 for a Tuesday" do
    schedule = Schedule.new nil, Date.parse('2008-10-07')
    schedule.send(:day_of_week).should == 1
  end

  it "returns 2 for a Wednesday" do
    schedule = Schedule.new nil, Date.parse('2008-10-08')
    schedule.send(:day_of_week).should == 2
  end

  it "returns 3 for a Thursday" do
    schedule = Schedule.new nil, Date.parse('2008-10-09')
    schedule.send(:day_of_week).should == 3
  end

  it "returns 4 for a Friday" do
    schedule = Schedule.new nil, Date.parse('2008-10-10')
    schedule.send(:day_of_week).should == 4
  end

  it "returns 5 for a Saturday" do
    schedule = Schedule.new nil, Date.parse('2008-10-11')
    schedule.send(:day_of_week).should == 5
  end

  it "returns 6 for a Sunday" do
    schedule = Schedule.new nil, Date.parse('2008-10-12')
    schedule.send(:day_of_week).should == 6
  end
end
