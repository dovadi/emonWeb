class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :input
end
