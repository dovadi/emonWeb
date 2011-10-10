class Input < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :last_value
end
