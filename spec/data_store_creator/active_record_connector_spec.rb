require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveRecordConnector do

  def stub_database(db)
    connection = mock(:adapter_name => db)
    ActiveRecordDatabase.any_instance.stubs(:db_connection).returns(connection)
  end

  it 'should raise an exception if database is not implemented' do
    stub_database('Sqlite')
    expect do
      ActiveRecordConnector.new.database
    end.to raise_error RuntimeError, "Database statement not implemented for Sqlite adapter"
  end

  it 'should return a mysql database if used in application' do
    stub_database('Mysql2')
    ActiveRecordConnector.new.database.class.should == MysqlDatabase
  end

  it 'should return a mysql database if used in application' do
    stub_database('PostgreSQL')
    ActiveRecordConnector.new.database.class.should == PostgresqlDatabase
  end

end