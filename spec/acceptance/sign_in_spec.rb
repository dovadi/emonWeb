require 'acceptance/acceptance_helper'

feature 'Sign in', %q{
  In order to get access to protected sections of the site
  A user
  Should be able to sign in
} do


  # Scenario: User is not signed up                       
  #   Given I am not logged in                            
  #   And no user exists with an email of "user@test.com" 
  #   When I go to the sign in page                       
  #   And I sign in as "user@test.com/please"             
  #   Then I should see "Invalid email or password."      
  #   And I go to the home page                           
  #   And I should be signed out                          
  # 
  # Scenario: User enters wrong password                                              
  #   Given I am not logged in                                                        
  #   And I am a user named "foo" with an email "user@test.com" and password "please" 
  #   When I go to the sign in page                                                   
  #   And I sign in as "user@test.com/wrongpassword"                                  
  #   Then I should see "Invalid email or password."                                  
  #   And I go to the home page                                                       
  #   And I should be signed out                                                      
  # 
  # Scenario: User signs in successfully with email                                   
  #   Given I am not logged in                                                        
  #   And I am a user named "foo" with an email "user@test.com" and password "please" 
  #   When I go to the sign in page                                                   
  #   And I sign in as "user@test.com/please"                                         
  #   Then I should see "Signed in successfully."                                     
  #   And I should be signed in                                                       
  #   When I return next time                                                         
  #   Then I should be already signed in                                              


  scenario 'User is not signed up' do
    visit '/'
    click_link 'Sign in'
    fill_in 'Email', :with => 'frank@dovadi.nl'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    page.should have_content('Invalid email or password.')
    
  end

end
