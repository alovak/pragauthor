Given /^I am a user named "([^"]*)" with an email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|
  User.new(:name => name,
            :email => email,
            :password => password,
            :password_confirmation => password).save!
end

When /^I sign in as "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Given %{I am not logged in}
  When %{I go to the sign in page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I press "Sign in"}
end

Given /^I am not logged in$/ do
  visit('/users/sign_out') # ensure that at least
end

Then /^I should be signed in$/ do
  Then %{I should see "Signed in successfully."}
end
