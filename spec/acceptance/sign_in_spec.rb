require 'acceptance/acceptance_helper'

feature 'Sign in', %q{
  In order to get access to protected sections of the site
  A user
  Should be able to sign in
} do

  background do
    @user = FactoryGirl.create(:user)
    visit homepage
    click_link 'Sign in'
  end

  scenario 'User is not signed up' do
    fill_in 'Email', :with => 'frank@dovadi.nl'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    within '.alert-message.alert' do
      page.should have_content('Invalid email or password.')
    end
  end

  scenario 'User enters wrong password' do
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => 'wrong_password'
    click_button 'Sign in'
    within '.alert-message' do
      page.should have_content('Invalid email or password.')
    end
  end

  scenario 'User signs in successfully with email' do
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => @user.password
    click_button 'Sign in'
    within '.alert-message.notice' do
      page.should have_content('Signed in successfully.')
    end
  end

end
