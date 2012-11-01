class UndefinedSqlStatementException < Exception; end

class ActiveRecordDatabase

  attr_reader :db_connection

  def initialize
    @db_connection = ActiveRecord::Base.connection
  end

  def create_table(name)
    db_connection.execute('ROLLBACK')
    db_connection.execute sql_statement(name) unless table_exist?(name)
  end

  def table_exist?(name)
    db_connection.tables.include?(name)
  end

  def sql_statement(name)
    raise UndefinedSqlStatementException
  end

end