require File.dirname(__FILE__) + '/../spec_helper'

describe DataStoreCreator do

  describe 'DataStoreCreator' do
    before(:each) do
      @db_connector = mock
      @db_connector.stubs(:adapter_name).returns('undefined')
      @creator = DataStoreCreator.new(12345)
      @creator.stubs(:db_connection).returns(@db_connector)
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
    describe 'create table' do
      it 'should create all the correct tables' do
        @creator.expects(:create_table).with('data_store_12345')
        @creator.expects(:create_table).with('data_store_12345_one_min')
        @creator.expects(:create_table).with('data_store_12345_five_mins')
        @creator.expects(:create_table).with('data_store_12345_fifteen_mins')
        @creator.expects(:create_table).with('data_store_12345_one_hour')
        @creator.expects(:create_table).with('data_store_12345_four_hours')
        @creator.expects(:create_table).with('data_store_12345_twelve_hours')
        @creator.create_all_tables
      end
      it 'should create a table if not exists' do
        @creator.stubs(:timeslots).returns([])
        @creator.expects(:table_exist?).with('data_store_12345').returns(false)
        @creator.expects(:sql_statement).with('data_store_12345').returns('sql')
        @db_connector.expects(:execute).with('sql')
        @creator.create_all_tables
      end
    end
  end

  describe 'DataStoreCreator with undefined database adapter' do
    before(:each) do
      db_connector = mock(:adapter_name =>'undefined')
      @creator = DataStoreCreator.new(12345)
      @creator.stubs(:db_connection).returns(db_connector)
    end
    it 'should raise an UndefinedDatabaseAdapter expection' do
      expect do
        @creator.execute!
      end.to raise_error UndefinedDatabaseAdapter
    end
  end

  describe 'DataStoreCreator for PostgreSQL' do
    before(:each) do
      @db_connector = mock(:adapter_name => 'PostgreSQL')
      @creator = DataStoreCreator.new(12345)
      @creator.stubs(:db_connection).returns(@db_connector)
    end
    it 'should initialize a DataStorePostgresCreator' do
      postgres = mock
      postgres.expects(:create_all_tables)
      DataStorePostgresCreator.expects(:new).with(12345).returns(postgres)
      @creator.execute!
    end
  end

  describe 'DataStoreCreator for Mysql2' do
    before(:each) do
      @db_connector = mock(:adapter_name => 'Mysql2')
      @creator = DataStoreCreator.new(12345)
      @creator.stubs(:db_connection).returns(@db_connector)
    end
    it 'should initialize a DataStoreMysqlCreator' do
      mysql = mock
      mysql.expects(:create_all_tables)
      DataStoreMysqlCreator.expects(:new).with(12345).returns(mysql)
      @creator.execute!
    end
  end

end

describe DataStoreMysqlCreator do

  it 'should return the correct sql statement' do
    @creator = DataStoreMysqlCreator.new(12345)
    @creator.sql_statement('data_store').include?("CREATE TABLE `data_store` ").should == true
  end

end

describe DataStorePostgresCreator do
  before(:each) do
    @db_connector = mock
    @db_connector.stubs(:adapter_name).returns('PostgreSQL')
    @creator = DataStorePostgresCreator.new(12345)
    @creator.stubs(:db_connection).returns(@db_connector)
  end

  it 'should return the correct sql statement' do
    @creator.sql_statement('data_store').include?("CREATE SEQUENCE data_store_id_seq").should == true
  end

  it 'should create a table with a ROLLBACK first' do
    @creator.expects(:table_exist?).with('data_store_12345').returns(false)
    @creator.expects(:sql_statement).with('data_store_12345').returns('sql')

    @db_connector.expects(:execute).with('ROLLBACK')
    @db_connector.expects(:execute).with('sql')
    @creator.create_table('data_store_12345')
  end

end