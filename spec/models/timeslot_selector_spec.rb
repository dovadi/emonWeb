require File.dirname(__FILE__) + '/../spec_helper'

describe TimeslotSelector do
  
  it 'should return the correct timeslot in case of a resolution of less than 800 data points' do
    TimeslotSelector.determine(:from => 0, :till => 7990).should     == nil
  end

  it 'should return the correct timeslot in case of a resolution of one minute' do
    TimeslotSelector.determine(:from => 0, :till => 8500).should     == :one_min
  end

  it 'should return the correct timeslot in case of a resolution of five minutes' do
    TimeslotSelector.determine(:from => 0, :till => 48001).should    == :five_mins
  end

  it 'should return the correct timeslot in case of a resolution of fifteen minutes' do
    TimeslotSelector.determine(:from => 0, :till => 240001).should   == :fifteen_mins
  end

  it 'should return the correct timeslot in case of a resolution of one hour' do
    TimeslotSelector.determine(:from => 0, :till => 720001).should   == :one_hour
  end

  it 'should return the correct timeslot in case of a resolution of four hours' do
    TimeslotSelector.determine(:from => 0, :till => 2880001).should  == :four_hours
  end

  it 'should return the correct timeslot in case of a resolution of twelve hours' do
    TimeslotSelector.determine(:from => 0, :till => 11520001).should == :twelve_hours
  end

end