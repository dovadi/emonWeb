class UndefinedProcessor < Exception; end

class Feed < ActiveRecord::Base

  before_create :set_corresponding_table_name
  after_create  :reset_corresponding_table_name

  #Force assigning table_name because with sanitizing it will add by default 'feeds'
  # Like for example: SELECT `feeds`.* FROM feed_236
  def self.from table_name
    self.table_name = table_name
    super table_name
  end

  attr_accessor :processors, :identified_by

  private

  def set_corresponding_table_name
    if identified_by.present?
      table_name = 'feed_' + identified_by.to_s
      Feed.table_name = table_name 
    end
  end

  def reset_corresponding_table_name
    Feed.table_name = 'feeds'
  end

end
