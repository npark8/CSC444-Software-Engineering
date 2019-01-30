Feature: Signup
This feature verifies the functionality of signup



Scenario: User sees root page
When I go to the root
Then I should see the sign up button
When I click sign up
Then I should see First Name
Given I fill in "First Name"
And I fill in "Last Name"
And I fill in "Email"
And I fill in "Password"
And I fill in "Confirmation"
And I fill in "Phone Number"
And I fill in "Address"
When I click "Create my account"
Then I should see Log In
