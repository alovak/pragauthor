Feature:
  A user
  Should be able to sing in, sign up and sign out from the index page

  Scenario: User is not signed in
    When I go to index page
    Then I should see "Sign in"
    Then I should see "Sign up"

  Scenario: User is signed in
    When I go to index page
    Then I should see "Sign out"
