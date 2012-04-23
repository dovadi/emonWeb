require 'acceptance/acceptance_helper'

feature 'Sign out', %q{
  To protect my account from unauthorized access
  A signed in user
  Should be able to sign out
} do

  background do
    @user = FactoryGirl.create(:user)
    sign_in_as @user
  end

  scenario 'Users signs out' do
    click_link 'Sign out'
    within '.alert-message.alert' do
      page.should have_content('You need to sign in or sign up before continuing.')
    end
  end

end
