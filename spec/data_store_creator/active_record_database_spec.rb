require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveRecordDatabase do

  it 'should have an ActiveRecord database connection' do
    database = ActiveRecordDatabase.new
    database.db_connection.should == ActiveRecord::Base.connection
  end

  describe 'create a table' do

    before(:each) do
      @db_connection = mock
      @database      = ActiveRecordDatabase.new
      @database.stubs(:db_connection).returns(@db_connection)
    end

    it 'should verify if a table exists' do
      tables = []
      @db_connection.expects(:tables).returns(tables)
      tables.expects(:include?).with('12345')
      @database.table_exist?('12345')
    end

    it 'should raise an UndefinedSqlStatementException when creating a table by default' do
      @database.stubs(:table_exist?).with('1234').returns(false)
      @db_connection.expects(:execute).with('ROLLBACK')
      expect do
        @database.create_table('1234')
      end.to raise_error UndefinedSqlStatementException
    end

    it 'should execute sql when creating a table' do
      @database.stubs(:table_exist?).with('1234').returns(false)
      @database.stubs(:sql_statement).with('1234').returns('sql')
      @db_connection.expects(:execute).with('ROLLBACK')
      @db_connection.expects(:execute).with('sql')
      
      @database.create_table('1234')
    end

  end

end