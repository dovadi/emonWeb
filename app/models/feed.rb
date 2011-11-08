class Feed < ActiveRecord::Base
  belongs_to :input
  attr_accessor :processors #, :identified_by
end
