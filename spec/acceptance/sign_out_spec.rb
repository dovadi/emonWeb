require 'acceptance/acceptance_helper'

feature 'Sign out', %q{
  To protect my account from unauthorized access
  A signed in user
  Should be able to sign out
} do

  background do
    @user = Factory(:user)
  end

  scenario 'Users signs out' do
    sign_in_as @user
    page.should have_content @user.email
    click_link 'Sign out'
    within '.alert-message.notice' do
      page.should have_content('Signed out successfully.')
    end
  end

end
