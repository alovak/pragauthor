@time_travel
Feature:
  As Inez
  I want to upload Smashwords files
  In order to view sale statistics

  Background:
    Given today is "08 Jun 2011"
    Given I sign in as "Inez"

  Scenario: see Smashwords total statistics for uploaded books
    Given I upload "SmashWords_salesReport-2011-06-08.xls"
    And I navigated to "Books"
    When I look statistics for "The First Book"
    Then I should see "21" units were sold by "Smashwords"
    When I look statistics for "The Second Book"
    Then I should see "4" units were sold by "Smashwords"
    When I look statistics for "The Third Book"
    Then I should see "8" units were sold by "Smashwords"
    When I look statistics for "The Fourth Book"
    Then I should see "3" units were sold by "Smashwords"

  Scenario: see monthly statistics for uploaded books
    Given I upload "SmashWords_salesReport-2011-06-08.xls"
    And I navigated to "Books"
    When I look statistics for "The First Book"
    Then I should see "1" units were sold in "May" by "Smashwords"
    Then I should see "3" units were sold in "Mar" by "Smashwords"
    When I look statistics for "The Second Book"
    Then I should see "3" units were sold in "May" by "Smashwords"
    Then I should see "1" units were sold in "Mar" by "Smashwords"
    When I look statistics for "The Third Book"
    Then I should see "6" units were sold in "May" by "Smashwords"
    Then I should see "2" units were sold in "Mar" by "Smashwords"
    When I look statistics for "The Fourth Book"
    Then I should see "3" units were sold in "May" by "Smashwords"

  Scenario: see how much money I earned 
    Given I upload "SmashWords_salesReport-2011-06-08.xls"
    And I navigated to "Books"
    When I look statistics for "The First Book"
    Then I should see "$8.59" were earned on "Smashwords"
    When I look statistics for "The Second Book"
    Then I should see "$1.20" were earned on "Smashwords"
    When I look statistics for "The Third Book"
    Then I should see "$3.35" were earned on "Smashwords"
    When I look statistics for "The Fourth Book"
    Then I should see "$2.06" were earned on "Smashwords"
