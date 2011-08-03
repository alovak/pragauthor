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
