require File.dirname(__FILE__) + '/../spec_helper'

describe PostgresqlDatabase do

  it 'should return the correct sql statement' do
    database  = PostgresqlDatabase.new
    database.sql_statement('data_store').include?("CREATE SEQUENCE data_store_id_seq").should == true
  end

end