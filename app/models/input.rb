class NoUserIdGiven < Exception; end
class UndefinedProcessorException < Exception; end

class Input < ActiveRecord::Base

  include DataStoreSql

  belongs_to :user
  has_many :feeds, :dependent => :destroy

  serialize :processors

  validates_presence_of   :name, :last_value
  validates_uniqueness_of :name, :scope => :user_id

  class_attribute :user_identifier, :input_attributes

  before_save :store_and_process_data

  attr_accessible :name, :last_value, :user_id, :processors

  def self.create_or_update(attributes)
    self.input_attributes = attributes.symbolize_keys!
    cleanup_input_attributes!
    extract_user_id_from_input_attributes
    process_input_attributes
  end

  def define_processor!(processor, argument)
    if storing_data_needed?(processor.to_sym)
      feed = feeds.create!(:name => argument, :user_id => user_id)
      add_processor(processor, feed.id)
    else
      add_processor(processor, argument)
    end
  end

  def define_processors(parameters)
    (1..(parameters.size/2)).each do |nr|
      processor = parameters['processor_' + nr.to_s]
      argument  = parameters['argument_' + nr.to_s]
      define_processor!(processor.to_sym, argument) if processor.present? && argument.present?
    end
  end

  private

  ##################################
  # Private class methods          #
  ##################################

  def self.cleanup_input_attributes!
    [:controller, :action, :auth_token].each {|key| self.input_attributes.delete(key)}
  end

  def self.extract_user_id_from_input_attributes
    raise NoUserIdGiven unless self.input_attributes.keys.include?(:user_id)
    self.user_identifier = self.input_attributes.delete(:user_id)
  end

  def self.process_input_attributes
    self.input_attributes.each do |key, value|
      existing_input = self.find_by_name_and_user_id(key.to_s, self.user_identifier)
      if existing_input
        existing_input.touch(:updated_at) if existing_input.last_value.to_f == value.to_f
        existing_input.update_attribute(:last_value, value)
      else
        create!(:name => key.to_s, :last_value => value, :user_id => self.user_identifier)
      end
    end
  end

  ##################################
  # Private instance methods       #
  ##################################

  # Because of serialize we use a double save when adding a new processor
  # AR doesn't set the record as changed if using
  # self.processors << [processor, argument] 
  # and it won't trigger callback store_and_process_data
  def add_processor(processor, argument)
    if self.processors.nil?
      self.processors = [[processor, argument]]
      save!
    else
      new_processors = self.processors
      new_processors << [processor, argument]
      self.processors = nil
      save!
      self.processors = new_processors
      save!
    end
  end

  def store_and_process_data
    if changes['processors'].present?
      check_data_store_tables
    else
      store_data
    end
  end

  def store_data
    if processors.present?
      processed_value = last_value
      processors.each do |processor|
        begin
          processor_name = (processor[0].to_s.camelize + 'Processor')
          processor_instance = processor_name.constantize.new(processed_value, processor[1])
        rescue NameError => e
          raise UndefinedProcessorException, "Undefined processor #{processor_name}"
        end
        processed_value = processor_instance.perform
      end
    end
  end

  def check_data_store_tables
    if self.processors.present?
      self.processors.each { |processor| verify_table('data_store_' + processor[1].to_s) if storing_data_needed?(processor[0]) }
    end
  end

  def storing_data_needed?(processor)
    Processor.data_stores.include?(processor.to_sym)
  end

  def verify_table(table_name)
    begin
      DataStore.from(table_name).count
    rescue ActiveRecord::StatementInvalid
      create_data_store_tables(table_name)
    end
  end

end
