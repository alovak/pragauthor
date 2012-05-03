@wip
Feature:
  As an author
  I want to track my LeanPub sales

  Scenario: 
    Given I have a LeanPub account
    When my LeanPub account was synchronized
      Then I should have imported books for my LeanPub account with sales
