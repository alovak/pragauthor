Given /^I sign in as "([^"]*)"$/ do |name|
  email = "#{name.downcase}@test.com"
  password = ::SecureRandom.hex(10)

  steps %Q{
    Given I am a user named "#{name}" with an email "#{email}" and password "#{password}"
    And I sign in as "#{email}" and password "#{password}"
    Then I should be signed in
  }
end

Given /^I am a user named "([^"]*)" with an email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|

  user = User.new(:name => name,
            :email => email,
            :password => password,
            :password_confirmation => password)
  user.save!
  user.confirm!
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

Then /^I should be signed out$/ do
  And %{I should see "Sign up"}
  And %{I should see "Sign in"}
  And %{I should not see "Sign out"}
end
