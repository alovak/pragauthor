@time_travel
Feature:
  As Inez
  I want to upload Barnes&Noble files
  In order to view sale statistics

  Background:
    Given today is "08 Jun 2011"
    And I sign in as "Inez"

  Scenario: see Barnes&Noble total statistics for uploaded books
    Given I upload "BNsales_June2011.xls"
    When I look statistics for "The First Book"
    Then I should see "3" units were sold by "Barnes&Noble"
    When I look statistics for "The Second Book"
    Then I should see "18" units were sold by "Barnes&Noble"

  Scenario: see monthly statistics for uploaded books
    Given I upload "BNsales_May2011.xls"
    And I upload "BNsales_June2011.xls"
    When I look statistics for "The First Book"
    Then I should see "8" units were sold in "May" by "Barnes&Noble"
    Then I should see "3" units were sold in "Jun" by "Barnes&Noble"
    When I look statistics for "The Second Book"
    Then I should see "11" units were sold in "May" by "Barnes&Noble"
    Then I should see "18" units were sold in "Jun" by "Barnes&Noble"

  Scenario: see how much money I earned 
    Given I upload "BNsales_May2011.xls"
    And I upload "BNsales_June2011.xls"
    When I look statistics for "The First Book"
    Then I should see "$4.40" were earned on "Barnes&Noble"
    Then I should see "$3.20" were earned in "May" by "Barnes&Noble"
    Then I should see "$3.20" were earned in "May"
    Then I should see "$1.20" were earned in "Jun" by "Barnes&Noble"
    Then I should see "$1.20" were earned in "Jun"
    When I look statistics for "The Second Book"
    Then I should see "$11.60" were earned on "Barnes&Noble"
    Then I should see "$4.40" were earned in "May" by "Barnes&Noble"
    Then I should see "$4.40" were earned in "May"
    Then I should see "$7.20" were earned in "Jun" by "Barnes&Noble"
    Then I should see "$7.20" were earned in "Jun"
