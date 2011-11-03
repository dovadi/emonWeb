class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :input

  before_save :process_data, :unless => Proc.new { |feed| feed.processors.nil? }

  attr_accessor :processors

  private

  def process_data
    processors.each_with_index do |processor, index|
      processed_value = value
      processor.each do |name, args|
        processor = (name.to_s.capitalize + 'Processor').constantize.new(processed_value, args)
        processed_value = processor.perform
      end
      self.send('processed_value_' + index.to_s + '=', processed_value)
    end
  end
end
