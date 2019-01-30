When(/^I go to the root$/) do
  visit root_path
end

Then(/^I should see the sign up button$/) do
  expect(page).to have_content("Sign up")

end

When(/^I click sign up$/) do
  click_link('Sign up')

end

Then(/^I should see First Name$/) do
  expect(page).to have_content("First Name")

end

Given (/^I fill in "First Name"$/) do
  fill_in('First Name', :with => 'John')

end

And (/^I fill in "Last Name"$/) do
  fill_in('Last Name', :with => 'Doe')

end

And (/^I fill in "Email"$/) do
  fill_in('Email', :with => 'wldnkim@gmail.com')

end

And (/^I fill in "Password"$/) do
  fill_in('Password', :with => 'password')

end

And (/^I fill in "Confirmation"$/) do
  fill_in('Confirmation', :with => 'password')

end

And (/^I fill in "Phone Number"$/) do
  fill_in('Phone Number', :with => '6472285815')

end

And (/^I fill in "Address"$/) do
  fill_in('Address', :with => '763 Bay St')

end

When (/^I click "Create my account"$/) do
  click_button 'Create my account'

end

Then(/^I should see Log In$/) do
  expect(page).to have_content("Log in")

end
