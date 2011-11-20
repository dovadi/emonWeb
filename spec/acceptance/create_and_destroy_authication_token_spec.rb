require 'acceptance/acceptance_helper'

feature 'Create and destroy authentication token', %q{
  In order to provide web access for my monitoring device
  As a user
  I want to create and destroy an authentication token
} do

  background do
    @user = Factory(:user)
    sign_in_as @user
  end

  scenario 'Create authentication token' do
    click_link 'Edit account'
    page.should have_content('Token Empty')
    click_link 'Generate Token'
    @user.reload
    page.should have_content(@user.authentication_token)
    page.should have_content('You can use this url to login')
    page.should have_content(@user.api_read_token)
    page.should have_content(root_path(:auth_token => @user.authentication_token))
  end

  scenario 'Destroy authentication token' do
    @user.reset_authentication_token!
    @user.reload
    click_link 'Edit account'
    page.should have_content(@user.authentication_token)
    click_link 'Delete Token'
    page.should have_content('Token Empty')
  end

end
