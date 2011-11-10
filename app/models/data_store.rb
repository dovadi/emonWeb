class DataStore < ActiveRecord::Base
  before_create :set_corresponding_table_name
  after_create  :reset_corresponding_table_name

  #Force assigning table_name because with sanitizing it will add by default 'data_stores'
  #Like for example: SELECT `datastores`.* FROM data_store_236
  def self.from name
    name = 'data_store_' + name.to_s if name.is_a?(Integer)
    self.table_name = name
    super name
  end

  attr_accessor :identified_by

  private

  def set_corresponding_table_name
    if identified_by.present?
      table_name = 'data_store_' + identified_by.to_s
      DataStore.table_name = table_name 
    end
  end

  def reset_corresponding_table_name
    DataStore.table_name = 'data_stores'
  end
end