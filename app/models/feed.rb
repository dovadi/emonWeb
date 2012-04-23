class Feed < ActiveRecord::Base
  belongs_to :input
  belongs_to :user
  attr_accessible :name, :last_value, :user_id, :input_id
end
