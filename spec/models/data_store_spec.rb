require File.dirname(__FILE__) + '/../spec_helper'

describe DataStore do

  describe 'DataStore assigned to table with a suffix based on a identifier' do
    before(:each) do
      drop_data_stores
      DataStore.table_name = 'data_stores'
      @attr = {:value => 252.55, :identified_by => '236'}
    end

    it 'should set the correct table_name' do
      DataStore.expects(:table_name=).with('data_store_236')
      DataStore.expects(:table_name=).with('data_stores')
      DataStore.create(@attr)
    end

    it 'should trigger the callback to calculate average values' do
      DataStore.expects(:table_name=).with('data_store_236')
      DataStore.expects(:table_name=).with('data_stores')
      DataStore.any_instance.expects(:calculate_one_min_average)
      DataStore.create(@attr)
    end
  end

  describe 'from' do
    it 'should force assign table_name' do
      DataStore.expects(:table_name=).with('data_store_2')
      DataStore.from('data_store_2')
    end

    it 'should force assign table_name with the use of a shorcut of the integer only' do
      DataStore.expects(:table_name=).with('data_store_2')
      DataStore.from(2)
    end
  end

  describe 'DataStore assigned to table with a suffix based on a identifier and a timeslot' do
    before(:each) do
      DataStore.table_name = 'data_stores'
      @attr = {:value => 252.55, :identified_by => '236', :timeslot => 'one_min'}
    end

    it 'should set the correct table_name' do
      DataStore.expects(:table_name=).with('data_store_236_one_min')
      DataStore.expects(:table_name=).with('data_stores')
      DataStore.create(@attr)
    end
  end

  describe 'fetch' do

    before(:each) do
      drop_data_stores
      @user = FactoryGirl.create(:user)
      @user.reset_api_read_token!
      @from = (Time.now - 1.hour).utc.to_i
      @till =  Time.now.utc.to_i
    end
    
    it 'should return an empty array if no correct options are given' do
      DataStore.fetch(:from => @from, :till => @till).should == []
    end

    it 'should perform the correct query' do
      select  = mock
      select.expects(:select).with([:value, :created_at]).returns([])
      order   = mock
      order.expects(:order).with('created_at DESC').returns(select)
      records = mock
      records.expects(:where)
             .with('created_at >= ? AND created_at <= ?', Time.at(@from).utc.to_s, Time.at(@till).utc.to_s)
             .returns(order)
      DataStore.expects(:from).with(1, nil).returns(records)
      DataStore.fetch(:from => @from.to_i, :till => @till.to_i, :feed_id => 1)
    end
  
    it 'should return the correct data' do
      @input = Input.new
      @input.create_data_store_tables('data_store_1')
      ds1 = DataStore.create!(:value => 100, :identified_by => 1)
      ds2 = DataStore.create!(:value => 200, :identified_by => 1)
      data = DataStore.fetch(:from => @from.to_i, :till => @till.to_i + 10, :feed_id => 1)
      data.size.should == 2
      data.include?([ds1.created_at.utc.to_i * 1000, ds1.value]).should == true
      data.include?([ds2.created_at.utc.to_i * 1000, ds2.value]).should == true
    end
  end


end
