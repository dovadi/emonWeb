require File.dirname(__FILE__) + '/../spec_helper'

describe DataAverage do

  describe 'DataAverage calculate! average' do
     before(:each) do
       @input = Input.new
       @input.create_data_store_tables('data_store_789')
     end

     it 'should calculate average! (one_min)' do
       DataStore.create(:value => 1, :identified_by => 789)
       DataStore.create(:value => 2, :identified_by => 789)

       DataAverage.calculate!(789, :one_min)
       data = DataStore.from(789, :one_min).last
       data.value.should == 1.5
     end

     it 'should calculate average for every other timeslot' do
       DataStore.create(:value => 1, :identified_by => 789)
       DataStore.create(:value => 2, :identified_by => 789)

       DataAverage.calculate!(789, :one_hour)
       data = DataStore.from(789, :one_hour).last
       data.value.should == 1.5
     end

     after(:each) do
       drop_data_stores
     end
   end

end