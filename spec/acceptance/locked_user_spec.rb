require 'acceptance/acceptance_helper'

feature 'Locked user', %q{
  In order to prevent my account being hacked
  As a user
  I want my account to be locked after too many failed attempts
} do

  background do
    reset_mailer
    @user = FactoryGirl.create(:user)
    visit homepage
    click_link 'Sign in'
  end

  scenario 'User gets locked after too many failed attempts, but unlocks it again' do
    4.times do
      fill_in 'Email', :with => @user.email
      fill_in 'Password', :with => 'wrong_password'
      click_button 'Sign in'
    end

    within '.alert' do
      page.should have_content('Your account is locked.')
    end

    unread_emails_for(@user.email).size.should >= parse_email_count(1)
    open_email(@user.email)
    current_email.default_part_body.to_s.should have_content 'Your account has been locked due to an excessive amount of unsuccessful sign in attempts.'
    click_first_link_in_email

    within '.alert-success' do
      page.should have_content('Your account was successfully unlocked. You are now signed in.')
    end
  end

end
