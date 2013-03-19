require File.dirname(__FILE__) + '/../spec_helper'

describe DataStoreCreator do
  
  describe 'DataStoreCreator' do
    before(:each) do
      @database = mock
      @creator = DataStoreCreator.new({:identifier => 12345, :database => @database})
    end
    it 'should have an identifier' do
      @creator.identifier.should == 12345
    end
    it 'should have a table_name' do
      @creator.table_name.should == 'data_store_12345'
    end
    it 'should have timeslots' do
      @creator.timeslots.should == [:one_min, :five_mins, :fifteen_mins, :one_hour, :four_hours, :twelve_hours]
    end

    it 'should create all the correct tables' do
      @database.should_receive(:create_table).with('data_store_12345')
      @database.should_receive(:create_table).with('data_store_12345_one_min')
      @database.should_receive(:create_table).with('data_store_12345_five_mins')
      @database.should_receive(:create_table).with('data_store_12345_fifteen_mins')
      @database.should_receive(:create_table).with('data_store_12345_one_hour')
      @database.should_receive(:create_table).with('data_store_12345_four_hours')
      @database.should_receive(:create_table).with('data_store_12345_twelve_hours')
      @creator.execute!
    end
  end

  it 'should work with a mysql database by default' do
    creator = DataStoreCreator.new(:identifier => 12345)
    creator.database.class.should == MysqlDatabase
  end
end
