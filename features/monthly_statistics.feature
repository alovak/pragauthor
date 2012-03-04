@time_travel
Feature:
  As Inez
  I want to view montly sale statistics
  In order to ?

  Background:
    Given today is "08 Jun 2011"
    And I sign in as "Inez"

  Scenario: see monthly statistics for uploaded books
    Given I upload "BNsales_May2011.xls"
    And I upload "BNsales_June2011.xls"
    And I upload "SmashWords_salesReport-2011-06-08.xls"
    And I navigated to "Books"
    When I look statistics for "The First Book"
    Then I should see "9" units were sold in "May"
    Then I should see "3" units were sold in "Jun"
    When I look statistics for "The Second Book"
    Then I should see "14" units were sold in "May"
    Then I should see "18" units were sold in "Jun"


