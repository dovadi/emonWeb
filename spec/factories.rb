require 'factory_girl'

FactoryGirl.define do

  factory :user do
    email 'user@test.com'
    password "password"
  end

end
