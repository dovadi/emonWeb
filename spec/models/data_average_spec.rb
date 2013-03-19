require File.dirname(__FILE__) + '/../spec_helper'

describe DataAverage do

  describe 'DataAverage' do
    before(:each) do
      drop_data_stores
      creator = DataStoreCreator.new({:identifier => 789, :database => ActiveRecordConnector.new.database})
      creator.execute!
      DataStore.create!(:value => 1, :identified_by => 789, :created_at => Time.parse('2012-08-07 11:01:57').utc)
      DataStore.create!(:value => 2, :identified_by => 789, :created_at => Time.parse('2012-08-07 11:01:58').utc)
    end

    it 'should do nothing if timeslot is nil' do
      DataAverage.calculate!(789, nil).should be_nil
    end

    it 'should calculate average! (one_min)' do
      Calculator.should_receive(:next).with(:one_min, anything).and_return(nil)
      DataAverage.calculate!(789, :one_min)
      data = DataStore.from(789, :one_min).last
      data.value.should == 1.5
    end

    it 'should calculate average for every other timeslot' do
      Calculator.should_receive(:next).with(:four_hours, anything).and_return(nil)
      DataAverage.calculate!(789, :four_hours)
      data = DataStore.from(789, :four_hours).last
      data.value.should == 1.5
    end

    it 'should calculate average! (one_min) if there is already another record stored' do
      DataStore.create!(:value => 4.5, :identified_by => 789, :timeslot => :one_min, :created_at => Time.parse('2012-08-07 11:01:59').utc)
      DataStore.any_instance.stub(:created_at).and_return(Time.parse('2012-08-07 10:00:00').utc) #force calculating an average
      Calculator.should_receive(:next).with(:one_min, anything).and_return(nil)
      DataAverage.calculate!(789, :one_min)
      data = DataStore.from(789, :one_min).last
      data.value.should == 1.5
    end

    after(:each) do
      drop_data_stores
    end
  end

end