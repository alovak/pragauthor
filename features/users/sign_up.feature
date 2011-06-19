Feature: Sign up
  In order to get access to protected sections of the site
  A user
  Should be able to sign up

    Scenario: User signs up with valid data
      Given I am not logged in
      When I go to the sign up page
      And I fill in "Email" with "user@test.com"
      And I fill in "Password" with "please"
      And I fill in "Password confirmation" with "please"
      And I press "Sign up"
      Then I should see "You will receive an email with instructions about how to confirm your account in a few minutes."
      Then I should receive an email to "user@test.com"
      When I open the email
      Then I should see "Confirmation instructions" in the email subject
      And I should see the email delivered from "support@indie.com"
      And I should see "Welcome user@test.com!" in the email body
      And I should see "You can confirm your account through the link below:" in the email body
      When I follow "Confirm my account" in the email
      Then I should see "Your account was successfully confirmed."
      And I should see "You are now signed in."
      And I should see "Home page"

    Scenario: User signs up with invalid email
      Given I am not logged in
      When I go to the sign up page
      And I fill in "Email" with "invalidemail"
      And I fill in "Password" with "please"
      And I fill in "Password confirmation" with "please"
      And I press "Sign up"
      Then I should see "Email is invalid"

    Scenario: User signs up without password
      Given I am not logged in
      When I go to the sign up page
      And I fill in "Email" with "user@test.com"
      And I fill in "Password" with ""
      And I fill in "Password confirmation" with "please"
      And I press "Sign up"
      Then I should see "Password can't be blank"

    Scenario: User signs up without password confirmation
      Given I am not logged in
      When I go to the sign up page
      And I fill in "Email" with "user@test.com"
      And I fill in "Password" with "please"
      And I fill in "Password confirmation" with ""
      And I press "Sign up"
      Then I should see "Password doesn't match confirmation"

    Scenario: User signs up with password and password confirmation that doesn't match
      Given I am not logged in
      When I go to the sign up page
      And I fill in "Email" with "user@test.com"
      And I fill in "Password" with "please"
      And I fill in "Password confirmation" with "please1"
      And I press "Sign up"
      Then I should see "Password doesn't match confirmation"
