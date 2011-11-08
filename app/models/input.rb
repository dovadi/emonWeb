class NoUserIdGiven < Exception; end

class Input < ActiveRecord::Base
  belongs_to :user

  validates_presence_of   :name, :last_value
  validates_uniqueness_of :name, :scope => :user_id

  serialize :processors

  class_attribute :user_identifier, :input_attributes

  before_save :store_and_process_data

  def self.create_or_update(attributes)
    self.input_attributes = attributes.symbolize_keys!
    cleanup_input_attributes!
    extract_user_id_from_input_attributes
    process_input_attributes
  end

  private

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

  def store_and_process_data
    check_feed_tables if changes['processors'].present?
  end

  def check_feed_tables
    processors.each { |processor| verify_table('feed_' + processor[1].to_s) if storing_data_needed?(processor[0]) }
  end

  def storing_data_needed?(processor)
    [:log_to_feed, :power_to_kwh, :power_to_kwh_per_day].include?(processor)
  end

  def verify_table(table_name)
    begin
      Feed.from(table_name).count
    rescue ActiveRecord::StatementInvalid
      create_table(table_name)
    end
  end

  def create_table(table_name)
    logger.info 'Create new feed table: #{table_name}'
    sql = "CREATE TABLE `#{table_name}` (
            `value` float NOT NULL,
            `created_at` datetime NOT NULL
          ) ENGINE=InnoDB"
    ActiveRecord::Base.connection.execute(sql)
  end

end
