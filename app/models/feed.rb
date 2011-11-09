class Feed < ActiveRecord::Base
  belongs_to :input
  attr_accessor :processors
end
