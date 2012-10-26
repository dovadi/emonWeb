class UndefinedDatabaseAdapter < Exception; end

class DataStoreCreator

  attr_reader :table_name, :identifier

  def initialize(identifier)
    @identifier  = identifier
    @table_name  = base_table_name + '_' + identifier.to_s
  end

  def timeslots
    [:one_min, :five_mins, :fifteen_mins, :one_hour, :four_hours, :twelve_hours]
  end

  def execute!
    creator = case db_connection.adapter_name
    when 'PostgreSQL'
      DataStorePostgresCreator.new identifier
    when 'Mysql2'
      DataStoreMysqlCreator.new identifier
    else
      raise UndefinedDatabaseAdapter
    end
    creator.create_all_tables
  end

  def create_all_tables
    create_table(table_name)
    timeslots.each do |timeslot|
      name = table_name + '_' + timeslot.to_s
      create_table(name) 
    end
  end

  private

  def base_table_name
    'data_store'
  end

  def db_connection
    ActiveRecord::Base.connection
  end

  def table_exist?(name)
    db_connection.execute('ROLLBACK')
    db_connection.tables.include?(name)
  end

  def create_table(name)
    db_connection.execute sql_statement(name) unless table_exist?(name)
  end

  def sql_statement(name)
    raise UndefinedDatabaseAdapter
  end

end

class DataStoreMysqlCreator < DataStoreCreator

  def sql_statement(name)
    "CREATE TABLE `#{name}` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `value` float NOT NULL,
    `created_at` datetime NOT NULL,
    `updated_at` datetime NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB"
  end

end

class DataStorePostgresCreator < DataStoreCreator

  def create_table(name)
    db_connection.execute('ROLLBACK')
    super name
  end

  def sql_statement(name)
    "CREATE TABLE #{name} (
    id integer NOT NULL,
    value double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
    );

    CREATE SEQUENCE #{name}_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    ALTER SEQUENCE #{name}_id_seq OWNED BY #{name}.id;

    ALTER TABLE #{name} ALTER COLUMN id SET DEFAULT nextval('#{name}_id_seq'::regclass);

    ALTER TABLE ONLY #{name}
    ADD CONSTRAINT #{name}_pkey PRIMARY KEY (id);"
  end

end

