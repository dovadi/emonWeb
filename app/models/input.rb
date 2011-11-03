class NoUserIdGiven < Exception; end

class Input < ActiveRecord::Base
  belongs_to :user
  has_many   :feeds, :dependent => :destroy

  validates_presence_of   :name, :last_value
  validates_uniqueness_of :name, :scope => :user_id

  serialize :processors

  after_save :store_value

  class_attribute :user_identifier, :input_attributes

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

  def store_value
    Feed.create!(:value => last_value, :user_id => user_id, :input_id => id) if user_id
  end
end
