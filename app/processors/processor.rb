class Processor

  attr_accessor :value, :argument

  def self.store?
    false
  end

  def self.data_stores
    array  = []
    processors.each { |processor| array << processor.to_sym if processor_class(processor).store? }
    array.sort
  end

  def self.descriptions
    array = []
    processors.each {|processor| array << processor_class(processor).description}
    array.sort
  end

  def initialize(value, argument)
    @value    = value
    @argument = argument
  end

  private

  def self.processor_class(processor)
    (processor + '_processor').camelize.constantize
  end

  def self.processors
    array = []
    Dir.entries(File.dirname(__FILE__)).each do |file|
      array << file.gsub(processor_file_regexp, '') if file.match(processor_file_regexp)
    end
    array
  end

  def self.processor_file_regexp
    /_processor\.rb/
  end

end