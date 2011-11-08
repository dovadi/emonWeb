class UndefinedProcessor < Exception; end

class Feed < ActiveRecord::Base

  before_save :process_data, :unless => Proc.new { |feed| feed.processors.nil? }

  before_create :set_corresponding_table_name
  after_create  :reset_corresponding_table_name

  #Force assigning table_name because with sanitizing it will add by default 'feeds'
  #Like for example: SELECT `feeds`.* FROM feed_236
  def self.from table_name
    self.table_name = table_name 
    super table_name
    self.table_name = 'feeds'
    self
  end

  attr_accessor :processors, :identified_by

  private

  def set_corresponding_table_name
    if identified_by.present?
      table_name = 'feed_' + identified_by.to_s
      Feed.table_name = table_name 
      begin
        Feed.count
      rescue ActiveRecord::StatementInvalid
        logger.info 'Create new feed table: #{table_name}'
        sql = "CREATE TABLE `#{table_name}` (
        `value` float DEFAULT NULL,
        `created_at` datetime DEFAULT NULL
        ) ENGINE=InnoDB"

        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end

  def reset_corresponding_table_name
    Feed.table_name = 'feeds'
  end

  def process_data
    processors.each_with_index do |processor, index|
      processed_value = value
      processor.each do |name, args|
        begin
          processor_name = (name.to_s.capitalize + 'Processor')
          processor = processor_name.constantize.new(processed_value, args)
        rescue NameError => e
          raise UndefinedProcessor, "Undefined processor #{processor_name}"
        end
        processed_value = processor.perform
      end
      self.send('processed_value_' + index.to_s + '=', processed_value)
    end
  end

end
