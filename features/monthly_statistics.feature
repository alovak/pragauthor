Feature:
  As Inez
  I want to view montly sale statistics
  In order to ?

  Background:
    Given I sign in as "Inez"

  Scenario: see monthly statistics for uploaded books
    Given I upload "BNsales_May2011.xls"
    And I upload "BNsales_June2011.xls"
    When I look statistics for "The First Book"
    Then I should see "8" units were sold in "May"
    Then I should see "3" units were sold in "Jun"
    When I look statistics for "The Second Book"
    Then I should see "11" units were sold in "May"
    Then I should see "18" units were sold in "Jun"


