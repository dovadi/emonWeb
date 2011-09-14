require 'acceptance/acceptance_helper'

feature 'Edit user', %q{
  As a registered user of the website
  I want to edit my user profile
  so I can change my username
} do

  background do
    @user = Factory(:user)
    sign_in_as @user
  end

  scenario 'I sign in and edit my account' do\
    click_link 'Edit account'
    fill_in 'Password', :with => 'dovadi'
    fill_in 'Password confirmation', :with => 'dovadi'
    fill_in 'Current password', :with => @user.password
    click_button 'Update'
    within '.alert-message.notice' do
      page.should have_content('You updated your account successfully.')
    end
  end

end
