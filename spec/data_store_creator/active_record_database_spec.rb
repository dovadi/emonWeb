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
      @database.stub(:db_connection).and_return(@db_connection)
    end

    it 'should verify if a table exists' do
      tables = []
      @db_connection.should_receive(:tables).and_return(tables)
      tables.should_receive(:include?).with('12345')
      @database.table_exist?('12345')
    end

    it 'should raise an UndefinedSqlStatementException when creating a table by default' do
      @database.stub(:table_exist?).with('1234').and_return(false)
      @db_connection.should_receive(:execute).with('ROLLBACK')
      expect do
        @database.create_table('1234')
      end.to raise_error UndefinedSqlStatementException
    end

    it 'should execute sql when creating a table' do
      @database.stub(:table_exist?).with('1234').and_return(false)
      @database.stub(:sql_statement).with('1234').and_return('sql')
      @db_connection.should_receive(:execute).with('ROLLBACK')
      @db_connection.should_receive(:execute).with('sql')
      
      @database.create_table('1234')
    end

  end

end