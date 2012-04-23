class DataStore < ActiveRecord::Base
  before_create :set_corresponding_table_name
 
  after_create  :calculate_one_min_average, :unless => Proc.new { |data_store| data_store.timeslot.present? }
  after_create  :reset_corresponding_table_name
 
  attr_accessor :identified_by, :timeslot

  #Force assigning table_name because with sanitizing it will add by default 'data_stores'
  #Like for example: SELECT `datastores`.* FROM data_store_236
  def self.from name, extension = nil
    if name.is_a?(Integer)
      name = 'data_store_' + name.to_s 
      name = name + '_' + extension.to_s if extension.present?
    end
    self.table_name = name
    super name
  end

  def self.fetch( options = {} )
    result = []
    get_data(options).each { |data_point| result << [data_point.created_at.utc.to_i * 1000, data_point.value] }
    result
  end

  def calculate_one_min_average
    DataAverage.calculate!(identified_by, :one_min) if self.created_at.sec < 10
  end

  private

  def self.get_data(options)
    if options[:from] && options[:till] && options[:feed_id]
      self.from(options[:feed_id], get_timeslot(options))
          .where('created_at >= ? AND created_at <= ?', get_time(options[:from]), get_time(options[:till]))
          .order('created_at DESC')
          .select([:value, :created_at])
    else
      []
    end
  end

  def self.get_timeslot(options)
    TimeslotSelector.determine(options)
  end

  def self.get_time(time)
    Time.at(time).utc.to_s
  end

  def set_corresponding_table_name
    if identified_by.present?
      table_name = 'data_store_' + identified_by.to_s
      table_name = table_name + '_' + timeslot.to_s if timeslot.present?
      DataStore.table_name = table_name 
    end
  end

  def reset_corresponding_table_name
    DataStore.table_name = 'data_stores'
  end

end
