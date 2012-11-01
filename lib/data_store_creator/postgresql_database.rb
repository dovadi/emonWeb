class PostgresqlDatabase < ActiveRecordDatabase

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
