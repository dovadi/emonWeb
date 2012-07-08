class Reset < ActiveRecord::Base
  attr_accessible :user_id, :reason
  belongs_to :user
  validates_presence_of :user_id
end
