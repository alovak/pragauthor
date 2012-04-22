Feature: review book statistics
  As Inez
  In order to know beter understand how book sales are going
  I want to see different sales reports for the book

  Scenario: review how much money I got and how much units were sold for this
    Given I have book sales
    When I navigated to the book page
      Then I should see royalties for the last year with units grouped by month

    When I set a period and currency
      Then I should see royalties for the period and currency 
