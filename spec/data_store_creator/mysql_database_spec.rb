require File.dirname(__FILE__) + '/../spec_helper'

describe MysqlDatabase do

  it 'should return the correct sql statement' do
    database = MysqlDatabase.new
    database.sql_statement('data_store').include?("CREATE TABLE `data_store` ").should == true
  end

end