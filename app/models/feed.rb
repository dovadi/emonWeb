class UndefinedProcessor < Exception; end

class Feed < ActiveRecord::Base
  belongs_to :input

  before_save :process_data, :unless => Proc.new { |feed| feed.processors.nil? }

  attr_accessor :processors

  private

  def process_data
    processed_value = last_value
    processors.each do |processor|
      begin
        processor_name = (processor[0].to_s.camelize + 'Processor')
        processor_instance = processor_name.constantize.new(processed_value, processor[1])
      rescue NameError => e
        raise UndefinedProcessor, "Undefined processor #{processor_name}"
      end
      processed_value = processor_instance.perform
    end
    write_attribute(:last_value, processed_value)
  end

end
