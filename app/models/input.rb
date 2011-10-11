class NoUserIdGiven < Exception; end

class Input < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :last_value
  validates_uniqueness_of :name, :scope => :user_id

  def self.create_or_update(attributes)
    attributes.symbolize_keys!
    raise NoUserIdGiven unless attributes.keys.include?(:user_id)
    attributes.delete(:controller)
    attributes.delete(:action)
    user_id = attributes.delete(:user_id)
    attributes.each do |key, value|
      existing_input = find_by_name_and_user_id(key.to_s, user_id)
      if existing_input
        existing_input.touch(:updated_at) if existing_input.last_value == value
        existing_input.update_attribute(:last_value, value)
      else
        create!(:name => key.to_s, :last_value => value)
      end
    end
  end
end
