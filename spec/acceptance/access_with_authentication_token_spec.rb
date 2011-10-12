require 'acceptance/acceptance_helper'

feature 'Access with authentication token', %q{
  In order to post data with a monitoring device
  As a device
  I want to have access with an authentication token
} do
  
  background do
    @user = Factory(:user)
    @user.reset_authentication_token!
    @user.reload
  end

  scenario 'Get access with an authentication token' do
    visit root_path(:auth_token => @user.authentication_token)
    within '.content' do
      page.should have_content('Listing inputs')
    end
  end

end