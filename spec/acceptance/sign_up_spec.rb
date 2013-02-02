require 'acceptance/acceptance_helper'

feature 'Sign up', %q{
  In order to get access to protected sections of the site
  As a user
  I want to be able to sign up
} do

  background do
    visit homepage
    first(:link, 'Sign up').click
  end

  scenario 'User signs up with valid data' do
    fill_in 'Email', :with => 'user@test.com'
    fill_in 'user_password', :with => 'please'
    fill_in 'user_password_confirmation', :with => 'please'
    click_button 'Sign up'
    within '.alert' do
      page.should have_content('Welcome! You have signed up successfully.')
    end
  end

  scenario 'User signs up with invalid email' do
    fill_in 'Email', :with => 'usertest.com'
    fill_in 'user_password', :with => 'please'
    fill_in 'user_password_confirmation', :with => 'please'
    click_button 'Sign up'
    within '#error_explanation' do
      page.should have_content('Email is invalid')
    end
  end

  scenario 'User signs up without password' do
    fill_in 'Email', :with => 'user@test.com'
    fill_in 'user_password_confirmation', :with => 'please'
    click_button 'Sign up'
    within '#error_explanation' do
      page.should have_content("Password can't be blank")
      page.should have_content("Password doesn't match confirmation")
    end
  end

  scenario 'User signs up without password confirmation' do
    fill_in 'Email', :with => 'user@test.com'
    fill_in 'user_password', :with => 'please'
    click_button 'Sign up'
    within '#error_explanation' do
      page.should have_content("Password doesn't match confirmation")
    end
  end

  scenario 'User signs up with mismatched password and confirmation' do
    fill_in 'Email', :with => 'user@test.com'
    fill_in 'user_password', :with => 'please'
    fill_in 'user_password_confirmation', :with => 'please1'
    click_button 'Sign up'
    within '#error_explanation' do
      page.should have_content("Password doesn't match confirmation")
    end
  end

end
