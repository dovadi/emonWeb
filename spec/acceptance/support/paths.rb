module NavigationHelpers
  # Put helper methods related to the paths in your application here.

  def homepage
    '/'
  end

  def forgot_your_password
    new_user_password_path
  end
end

RSpec.configuration.include NavigationHelpers, :type => :acceptance