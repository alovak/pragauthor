Feature: Sign out
  To protect my account from unauthorized access
  A signed in user
  Should be able to sign out

    Scenario: User signs out
      Given I am a user named "foo" with an email "user@test.com" and password "please"
      When I sign in as "user@test.com" and password "please"
      Then I should be signed in
      When I follow "Sign out"
      Then I should see "Signed out"
      When I go to the index page
      Then I should be signed out
