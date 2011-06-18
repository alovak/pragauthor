Feature:
  A user
  Should be able to sing in, sign up and sign out from the index page

  Scenario: User is not signed in
    When I go to the index page
    Then I should see "Welcome!"
    Then I should see "Sign in"
    Then I should see "Sign up"

  Scenario: User is signed in
    Given I am a user named "foo" with an email "user@test.com" and password "please"
    When I sign in as "user@test.com" and password "please"
    Then I should be signed in
    When I go to the index page
    Then I should see "Sign out"
