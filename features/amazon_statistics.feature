@time_travel
Feature:
  As Inez
  I want to upload Amazon files
  In order to view sale statistics

  Background:
    Given today is "08 Jul 2011"
    And I sign in as "Inez"

  Scenario: see Amazon total statistics for uploaded books
    Given I upload "kdp-report-04-2011.xls"
    When I look statistics for "The First Book"
    Then I should see "190" units were sold by "Amazon"
    When I look statistics for "The Second Book"
    Then I should see "13" units were sold by "Amazon"
    When I look statistics for "The Third Book"
    Then I should see "5" units were sold by "Amazon"

  Scenario: see monthly statistics for uploaded books
    Given I upload "kdp-report-04-2011.xls"
    Given I upload "kdp-report-07-2011.xls"
    When I look statistics for "The First Book"
    Then I should see "190" units were sold in "Apr" by "Amazon"
    Then I should see "2" units were sold in "Jul" by "Amazon"
    When I look statistics for "The Second Book"
    Then I should see "13" units were sold in "Apr" by "Amazon"
    Then I should see "1" units were sold in "Jul" by "Amazon"
    When I look statistics for "The Third Book"
    Then I should see "5" units were sold in "Apr" by "Amazon"
    Then I should see "1" units were sold in "Jul" by "Amazon"

  Scenario: see how much money I earned 
    Given I upload "kdp-report-04-2011.xls"
    When I look statistics for "The First Book"
    Then I should see "$66.58" were earned on "Amazon"
    When I look statistics for "The Second Book"
    Then I should see "$6.76" were earned on "Amazon"
    When I look statistics for "The Third Book"
    Then I should see "$1.75" were earned on "Amazon"
