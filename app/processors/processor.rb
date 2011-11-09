class Processor

  attr_accessor :value, :argument

  def self.store?
    false
  end

  def self.data_stores
    array  = []
    processors.each do |processor|
      data_store = (processor + 'Processor').camelize.constantize.store?
      array << processor.to_sym if data_store
    end
    array.sort
  end
  
  def self.descriptions
    array = []
    processors.each do |processor|
      array << (processor + 'Processor').camelize.constantize.description
    end
    array.sort
  end

  def initialize(value, argument)
    @value    = value
    @argument = argument
  end
  
  private
  
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