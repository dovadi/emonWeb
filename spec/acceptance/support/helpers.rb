module HelperMethods
  # Put helper methods you need to be available in all acceptance specs here.

  def sign_in_as user
    visit '/'
    click_link 'Sign in'
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => user.password
    click_button 'Sign in'
  end

end

RSpec.configuration.include HelperMethods, :type => :acceptance