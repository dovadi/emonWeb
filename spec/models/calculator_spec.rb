require File.dirname(__FILE__) + '/../spec_helper'

describe Calculator do

  it { Calculator }

  describe 'calculate next timeslot with :one_min' do
    it 'should return nil if the minutes cannot be dived by 5' do
      time = mock
      time.stubs(:min).returns(1)
      Calculator.next(:one_min, time).should be_nil
    end

    it 'should return :five_minutes if the minutes can be divided by 5' do
      time = mock
      time.stubs(:min).returns(5)
      Calculator.next(:one_min, time).should == :five_mins
    end
  end

  describe 'calculate next timeslot with :five_mins' do
    it 'should return nil if the minutes cannot be dived by 15' do
      time = mock
      time.stubs(:min).returns(1)
      Calculator.next(:five_mins, time).should be_nil
    end

    it 'should return :fifteen_minutes if the minutes can be divided by 15' do
      time = mock
      time.stubs(:min).returns(15)
      Calculator.next(:five_mins, time).should == :fifteen_mins
    end
  end

  describe 'calculate next timeslot with :fifteen_mins' do
    it 'should return nil if the minutes is 15 or more' do
      time = mock
      time.stubs(:min).returns(15)
      Calculator.next(:fifteen_mins, time).should be_nil
    end

    it 'should return :one_hour if the minutes can be divided by 15' do
      time = mock
      time.stubs(:min).returns(13)
      Calculator.next(:fifteen_mins, time).should == :one_hour
    end
  end

  describe 'calculate next timeslot with :one_hour' do
    it 'should return nil if the hours cannot be dived by 4' do
      time = mock
      time.stubs(:hour).returns(1)
      Calculator.next(:one_hour, time).should be_nil
    end

    it 'should return :four_hours if the hours can be divided by 4' do
      time = mock
      time.stubs(:hour).returns(4)
      Calculator.next(:one_hour, time).should == :four_hours
    end
  end

  describe 'calculate next timeslot with :four_hours' do
    it 'should return nil if the hours cannot be dived by 12' do
      time = mock
      time.stubs(:hour).returns(4)
      Calculator.next(:four_hours, time).should be_nil
    end

    it 'should return :twelve_hours if the hours can be divided by 12' do
      time = mock
      time.stubs(:hour).returns(12)
      Calculator.next(:four_hours, time).should == :twelve_hours
    end
  end

end