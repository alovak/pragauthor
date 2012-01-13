Feature: view app users
  In order to get information about service usage
  As an admin
  I can view detailed statistics

  Background:
    Given a lot of users with books

  Scenario: view detailed statistics
    When I sign in as admin
      Then should see how many users signed up
      And I should see how many users comfirmed their account 
      And I should see how many books uploaded into the system
      And I should see user list with book count
