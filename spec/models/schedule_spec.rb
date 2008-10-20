require File.dirname(__FILE__) + '/../spec_helper'

describe Schedule, '#days' do
  it "returns an array of days between start_at and end_at" do
    @start_at = Date.parse('2008-10-06')
    schedule = Schedule.new @start_at
    schedule.days.should == (@start_at..(@start_at + 4.weeks - 1.day)).to_a
  end
end

describe Schedule, '#days_range' do
  before :each do 
    @monday = Date.parse('2008-10-06')
    @thursday = Date.parse('2008-10-09')
    @sunday = Date.parse('2008-10-12')
    @schedule = Schedule.new @thursday
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