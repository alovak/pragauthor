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
  5.times do 
    user = Factory.create(:confirmed_user)
    5.times { Factory.create(:book, :user => user) }
  end
end

Given /^some unconfirmed users$/ do
  2.times { Factory.create :user }
end

Then /^I should see how many users comfirmed their account$/ do
  within(:css, ".users .confirmed") do
    page.should have_content("5")
  end
end

Then /^I should see how many books uploaded into the system$/ do
  within(:css, ".books .uploaded") do
    page.should have_content("25")
  end
end

Then /^I should see user list with book count$/ do
  within(:css, ".users .last") do
    User.all.each do |user|
      page.should have_content(user.name)
      page.should have_content(user.email)
      page.should have_content(user.books.count) if user.confirmed?
    end
  end
end

Then /^I should see how many users didn't confirmed their account$/ do
  within(:css, ".users .unconfirmed") do
    page.should have_content("2")
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
