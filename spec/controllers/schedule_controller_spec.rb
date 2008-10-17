require File.dirname(__FILE__) + '/../spec_helper'

describe ScheduleController, '#day_of_week' do
  it "returns 0 for a Monday" do
    date = Date.parse('2008-10-06')
    controller.send(:day_of_week, date).should == 0
  end

  it "returns 1 for a Tuesday" do
    date = Date.parse('2008-10-07')
    controller.send(:day_of_week, date).should == 1
  end

  it "returns 2 for a Wednesday" do
    date = Date.parse('2008-10-08')
    controller.send(:day_of_week, date).should == 2
  end

  it "returns 3 for a Thursday" do
    date = Date.parse('2008-10-09')
    controller.send(:day_of_week, date).should == 3
  end

  it "returns 4 for a Friday" do
    date = Date.parse('2008-10-10')
    controller.send(:day_of_week, date).should == 4
  end

  it "returns 5 for a Saturday" do
    date = Date.parse('2008-10-11')
    controller.send(:day_of_week, date).should == 5
  end

  it "returns 6 for a Sunday" do
    date = Date.parse('2008-10-12')
    controller.send(:day_of_week, date).should == 6
  end
end
