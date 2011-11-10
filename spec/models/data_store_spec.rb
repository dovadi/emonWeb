require File.dirname(__FILE__) + '/../spec_helper'

describe DataStore do

  it 'should be defined' do
    DataStore
  end

  describe 'DataStore assigned to table with a suffix based on a identifier' do
    before(:each) do
      DataStore.table_name = 'data_stores'
      @attr = {:value => 252.55, :identified_by => '236'}
    end

    it 'should set the correct table_name' do
      DataStore.expects(:table_name=).with('data_store_236')
      DataStore.expects(:table_name=).with('data_stores')
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

end
