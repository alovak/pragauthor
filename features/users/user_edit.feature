Feature: Edit User
  As a registered user
  I want to edit my user profile
  so I can change my username

    Scenario: I sign in and edit my account
      Given I am a user named "Inez" with an email "user@test.com" and password "please"
      When I sign in as "user@test.com" and password "please"
      Then I should be signed in
      And I should see "User: Inez"
      When I follow "Edit profile"
      And I fill in "Name" with "Adam"
      And I fill in "Current password" with "please"
      And I press "Update"
      And I go to the home page
      Then I should see "User: Adam"
