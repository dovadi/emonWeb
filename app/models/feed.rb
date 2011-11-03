class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :input

  before_save :process_data, :unless => Proc.new { |feed| feed.processors.nil? }

  attr_accessor :processors

  private

  def process_data
    processors.each do |process, args|
      processor = (process.to_s.capitalize + 'Processor').constantize.new(value, args)
      value = processor.perform
    end
  end
end
