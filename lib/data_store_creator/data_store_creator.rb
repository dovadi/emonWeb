class DataStoreCreator

  attr_reader :table_name, :identifier, :database

  def initialize(options = {})
    @database   = options[:database] || MysqlDatabase.new
    @identifier = options[:identifier]
    @table_name = base_table_name + '_' + identifier.to_s
  end

  def timeslots
    [:one_min, :five_mins, :fifteen_mins, :one_hour, :four_hours, :twelve_hours]
  end

  def execute!
    database.create_table(table_name)
    timeslots.each do |timeslot|
      database.create_table(name_with_extension(timeslot)) 
    end
  end

  private

  def name_with_extension(extension)
    table_name + '_' + extension.to_s
  end

  def base_table_name
    'data_store'
  end

end

