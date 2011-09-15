require 'acceptance/acceptance_helper'

feature 'Delete my account', %q{
  In order destroy all my data
  As a user
  I want to delete my account
} do

  background do
    @user = Factory(:user)
    sign_in_as @user
  end

  scenario 'delete user account' do
    click_link 'Edit account'
    click_link 'Cancel my account'
    User.count.should == 0
  end

end
