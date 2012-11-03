class ActiveRecordConnector

  attr_reader :connection

  def initialize
    @connection = ActiveRecordDatabase.new.db_connection
  end

  def database
    database = connection.adapter_name
    case database
    when 'PostgreSQL'
      PostgresqlDatabase.new
    when 'Mysql2'
      MysqlDatabase.new
    else
      raise RuntimeError, "Database statement not implemented for #{database} adapter"
    end
  end

end