require File.dirname(__FILE__) + '/../spec_helper'

describe DataAverage do

  describe 'DataAverage calculate! average' do
    before(:each) do
      drop_data_stores
      @input = Input.new
      @input.create_data_store_tables('data_store_789')
     
      DataStore.create(:value => 1, :identified_by => 789)
      DataStore.create(:value => 2, :identified_by => 789)
    end

    it 'should do nothing if timeslot is nil' do
      DataAverage.calculate!(789, nil).should be_nil
    end

    it 'should calculate average! (one_min)' do
      Calculator.expects(:next).with(:one_min, anything).returns(nil)
      DataAverage.calculate!(789, :one_min)
      data = DataStore.from(789, :one_min).last
      data.value.should == 1.5
    end

    it 'should calculate average for every other timeslot' do
      Calculator.expects(:next).with(:four_hours, anything).returns(nil)
      DataAverage.calculate!(789, :four_hours)
      data = DataStore.from(789, :four_hours).last
      data.value.should == 1.5
    end

    it 'should calculate average! (one_min) if there is already another record stored' do
      DataStore.create(:value => 4.5, :identified_by => 789, :timeslot => :one_min)
      DataStore.any_instance.stubs(:created_at).returns(Time.now - 1.hour) #force calculating an average
      Calculator.expects(:next).with(:one_min, anything).returns(nil)
      DataAverage.calculate!(789, :one_min)
      data = DataStore.from(789, :one_min).last
      data.value.should == 1.5
    end

    after(:each) do
      drop_data_stores
    end
  end

end