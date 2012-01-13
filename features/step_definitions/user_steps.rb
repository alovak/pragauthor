Given /^I sign in as "([^"]*)"$/ do |name|
  email = "#{name.downcase}@test.com"
  password = "test123pass"

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

Given /^a lot of users with books$/ do
  3.times do 
    Factory.create(:confirmed_user) do |user|
      5.times { Factory :book, :user => user }
    end
  end
end

Given /^I sign in as admin$/ do
  admin = Factory(:admin)

  visit "/admins/sign_in"

  fill_in "Email", with: admin.email
  fill_in "Password", with: admin.password

  click_button "Sign in"

  page.should have_content("Signed in successfully")
end
