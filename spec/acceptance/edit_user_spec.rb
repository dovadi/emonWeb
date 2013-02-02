require 'acceptance/acceptance_helper'

feature 'Edit user', %q{
  As a registered user of the website
  I want to edit my user profile
  so I can change my username
} do

  background do
    @user = FactoryGirl.create(:user)
    sign_in_as @user
  end

  scenario 'I sign in and edit my account' do\
    first(:link, 'Edit account').click
    fill_in 'user_password', :with => 'dovadi'
    fill_in 'user_password_confirmation', :with => 'dovadi'
    fill_in 'user_current_password', :with => @user.password
    click_button 'Update'
    within '.alert-success' do
      page.should have_content('You updated your account successfully.')
    end
  end

end
