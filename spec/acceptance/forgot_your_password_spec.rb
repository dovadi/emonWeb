require 'acceptance/acceptance_helper'

feature 'Forgot your password', %q{
  In order to sign in again after I forgot my password 
  As a user
  I want to reset my password
} do

  background do
    reset_mailer
    @user = Factory(:user)
    visit forgot_your_password
  end

  scenario 'Request a new password with a correct users email' do
    fill_in 'Email', :with => @user.email
    click_button 'Send me reset password instructions'
    within '.alert-message.notice' do
      page.should have_content('You will receive an email with instructions about how to reset your password in a few minutes.')
    end

    unread_emails_for(@user.email).size.should >= parse_email_count(1)
    open_email(@user.email)
    current_email.default_part_body.to_s.should have_content 'Someone has requested a link to change your password, and you can do this through the link below.'
    click_first_link_in_email

    page.should have_content('Change your password')

    fill_in 'New password', :with=> 'password'
    fill_in 'Confirm new password', :with=>'password'
    click_button "Change my password"

    within '.alert-message.notice' do
      page.should have_content('Your password was changed successfully. You are now signed in.')
    end
  end

end
