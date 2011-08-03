@time_travel
Feature:
  As Inez
  I want to upload Amazon files
  In order to view sale statistics

  Background:
    Given today is "08 Jun 2011"
    And I sign in as "Inez"

  Scenario: see Amazon total statistics for uploaded books
    Given I upload "kdp-report-04-2011.xls"
    When I look statistics for "The First Book"
    Then I should see "190" units were sold by "Amazon"
    When I look statistics for "The Second Book"
    Then I should see "13" units were sold by "Amazon"
    When I look statistics for "The Third Book"
    Then I should see "5" units were sold by "Amazon"

  # Scenario: see monthly statistics for uploaded books
    # Given I upload "BNsales_May2011.xls"
    # And I upload "BNsales_June2011.xls"
    # When I look statistics for "The First Book"
    # Then I should see "8" units were sold in "May" by "Barnes&Noble"
    # Then I should see "3" units were sold in "Jun" by "Barnes&Noble"
    # When I look statistics for "The Second Book"
    # Then I should see "11" units were sold in "May" by "Barnes&Noble"
    # Then I should see "18" units were sold in "Jun" by "Barnes&Noble"
